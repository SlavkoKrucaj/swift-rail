# Swiftrail

A gem command line tool to help with assembling test reports and pairing them with the [testrail](https://www.gurock.com/testrail) test cases

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'swiftrail'
```

And then execute:
```
$ bundle
```

## Usage

### Options

Mandatory options for all of the commands are
 
- `--test_classes=''` - regex for the path to swift tests
- `--test_rail_username=''` - username for TestRail account
- `--test_rail_password=''` - password for TestRail account
- `--test_rail_url=''` -  url for TestRail account
- `--run_id=''` - run_id for which you want to run the command

When running report you additionaly have to pass location of the test_reports
    - `--test-reports=''`

### Marking test cases

In your `swift` projects you can mark any test class or specific test with any number of TestRail test cases. To mark them
specify the `//testrail` and after that just list the corresponding **case**-ids. Example

```swift
//testrail C12344
class MyTests: XCTestCase {

    //testrail C12344, C3267231
    func test_first() {
    }

    //testrail C15
    func test_second() {
    }

    func test_third() {
    }
}

class MyOtherTests: XCTestCase {

    //testrail C5555
    func test_four() {
    }

    //testrail C15
    func test_five() {
    }

    func test_six() {
    }
}
```
### Report

To be able to report the results of the tests, you need to first generate xml junit reports. Once you have those, running
```
swiftrail report --test-reports='path/to/test/reports' --run_id:123 (all the other options should also be included)
```
will report the results to TestRail. Dependent on success/failure the tests on TestRail will be marked accordingly.

### Coverage

Coverage report will give you the percentage of test cases covered by your ui/unit/... tests.

```
swiftrail coverage --run_id:123 (all the other options should also be included)
```

### Lint

Lint will give you outadet case_ids that you have marked on your ui/unit tests, but no longer exist as test cases on TestRail.

```
swiftrail lint --run_id:123 (all the other options should also be included)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/slavkokrucaj/swift-rail. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Swiftrail project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/slavkokrucaj/swift-rail/blob/master/CODE_OF_CONDUCT.md).
