# Employees app

This is a fully-functioning Rails application running on Docker that solves the employees task.

It has been built upon my own [template application](https://github.com/Shannarra/rails7template), made so one can easily and painlessly bootstrap a Rails 7 application using Docker, with its own integrated CI/CD pipeline in GitHub Actions. This ensures that the app is up to engineering standards, including latest versions of Rails, Ruby and security checks (via Bundler Audit and Brakeman).

## How it works
The app itself consists of a simple model (called [`CommonEmployeeProject`](https://github.com/Shannarra/Petar-Angelov-employees/blob/master/app/models/common_employee_project.rb)) that allows for multiple file uploads.

The uploads themselves are handled by a very simple, but effective gem called [Carrierwave](https://github.com/carrierwaveuploader/carrierwave), allowing for extended options for what and where to store. For the purpose of this application, the app will allow only **CSV** files to be stored, as per requirements. You can see the uploader that handles it [here](https://github.com/Shannarra/Petar-Angelov-employees/blob/master/app/uploaders/common_employee_project_uploader.rb).

When a new `CommonEmployeeProject` record is saved to the database, the application will automatically start a Sidekiq background job asynchronously, that will handle parsing the CSV file provided, manipulates the data and stores it to the corresponding project record. 

### The worker
The background worker (workers got renamed to "jobs", but the API of the gem is still the same) can be found in the folder (app/sidekiq/find_employees_that_worked_longest_job.rb)[https://github.com/Shannarra/Petar-Angelov-employees/blob/master/app/sidekiq/find_employees_that_worked_longest_job.rb].

It works in several steps:

1. Initiate
The worker selects the latest `CommonEmployeeProject` that has been requested and updates its upload state to "processing". 
After that, it tries to parse the CSV file provided. If file is not in the correct format the upload state is directly set to "errorneous" and all work is stopped immediately.

2. Group Employees project-wise
Parse the file line by line, grouping all employees based on the projects they have worked, whilst keeping the information relatively unchanged.

ALL date formats are supported, so long as they can adhere to the core Ruby [Date#parse](https://ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/Date.html#method-c-parse) method. This means that the data is not constrained to one date format, and you can use whichever one you like. :)

3. After the employees have been grouped
Now we'd need to match the employees that have any overlap on one or more projects and collect relevant information. We can do this in several simple steps:

  - 3.0 Iterate through all projects, and for each project, iterate through all employees  
  - 3.1 Skip the current iteration if we are matching the same employee twice  
  - 3.2 Collect the tenure of the two employees, if it does not have any overlap - no need to do anything - so, skip this iteration.  
  - 3.3 If there is some overlap, prepare the table that stores the valuable overlap information (if needed)  
  - 3.4 Convert the employment overlap from a Date range to days and store it, increment the total amount the two employees have worked together  

4. Sanitize and save
After the data has been collected, clean it up, serialize it and store it into the project object. Mark the upload state to "uploaded" and enjoy :)

### Additional
Usually, Sidekiq workers ("jobs") are to be run via a rake task that gets executed from a scheduler (a cronjob in most cases). 

There is a task that can run the job (see `lib/tasks/upload_files.rake`), but either needs to be run manually via `rake upload_files:run`, or to be run in a crontab. Note that this will run all of the `CommonEmployeeProject`s that need to be run.


## Development setup
###### Please, make sure that you have turned your postgresql service off or you will be greeted with an error message saying that port 5432 is taken.
###### You can do that by running the command `sudo systemctl stop postgresql`

You can just run the [startup.sh](https://github.com/Shannarra/rails7template/edit/master/startup.sh) script:
```console
sh ./startup.sh --run
```

This will bootstrap the application, setup a database and migrate it to the latest version, install all dependencies AND start a local server on localhost:3000

Alternatively, if you can't run the shell script, you can bootstrap the application yourself by running the following few commands:

```sh
# make sure the binaries of the project have the privileges to work as expected
chmod u+x -R ./bin/*

# copy/rename the environment variables file
cp .env.example .env

# build the initial containers
docker compose build

# setup the database, including migrations and seeding
docker compose run --rm web rails db:setup
```

### Using the app after setup
Using the `startup.sh` script, you can skip the next step and make it so the application starts immediately after it has been built:
```console
sh startup.sh --run # -r works as well :) 
```

If you want to learn more about this script you can just call the `--help` option.

## Running the Rails app
```console
docker compose up --build
```
Then just navigate to http://localhost:3000
