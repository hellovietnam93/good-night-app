# GoodNight

We would like you to implement a “good night” application to let users track when do they go to bed and when do they wake up.
We require some restful APIS to achieve the following:
1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records of a user’s All following users’ sleep records. from the previous week, which are sorted based on the duration of All friends sleep length.

## TODO Plan

- [x] Init project
- [x] Init models
- [x] Setup base API response
- [x] Add API login
- [x] Add API create sleep time
- [x] Add API get list sleep time by user
- [x] Add API follow user

## API document

<!-- ADD later -->

## Getting Started

Here are steps to run the service locally:
*  Clone the code: git@github.com:hellovietnam93/good-night-app.git

```bash
git clone git@github.com:hellovietnam93/good-night-app.git
```

*  Install Ruby: ruby-3.1.4

```bash
rvm install 3.1.4
```

*  Install Rails: 7.0.6

```bash
gem install rails:7.0.6
```

*  Install PostgeSQL: 13

```bash
docker run --name postgres13 -p 5433:5432 -e POSTGRES_PASSWORD=12345678 -v pg-data:/var/lib/postgresql/data -d postgres:13
```

*  Bundle install

```bash
bundle install
```

*  Setup database

```bash
rails db:setup
```
*  Start server

```bash
rails s
```

## Evaluation

- [ ] Ruby best practices
    - Rubocop
    - bundle-audit check
    - brakeman
- [ ] API implemented
- [ ] Completeness: Did you complete the features? Are all the tests running?
    - All feature completed
    - UT: Minumum 84%
- [] Correctness: Does the functionality act in sensible, thought-out ways?
- [] Maintainability: Is it written in a clean, maintainable way?
- [] [Security: Have you identified potential issues and mitigated or documented them?](./documents/security.md)
- [] [Scalability: What scalability issues do you foresee in your implementation and how do you plan to work around those issues?](./documents/scalability.md)
- [] [Sample run](./documents/sample.md)

## Running the tests

**Before make a pull request, please make sure all test are passed locally.**

*  Unit test

```bash
rspec
```

* Generate Document

```bash
APIPIE_RECORD=examples rspec
```

*  Security check

```bash
brakeman
```

*export warning to file*

```bash
brakeman -o brakeman_results.html
```

*  Coding style

```bash
rubocop -a
```

*export warning to file*

```bash
rubocop -a --out rubocop.xml
```

*  Patch-level verification for bundler

```bash
bundle-audit check --update
```

*export warning to file*

```bash
bundle-audit check --update > bundle-audit.txt
```
