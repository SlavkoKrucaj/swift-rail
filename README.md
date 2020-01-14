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

#### QuickNimble support
If Quick/Nimble is used for generating tests, the above examples can't be used. 

In order for SwiftRail to detect which tests are linked to which cases ids, you need to add this custom context in your project:

```swift
public func testRail(_ ids: Int..., flags: FilterFlags = [:], closure: () -> Void) {
    let formattedTestrailCases = ids
        .map({ "C\($0)" })
        .joined(separator: " ")
    context(formattedTestrailCases, flags: flags, closure: closure)
}
```

and then you can use it this way in your tests:

```swift
class MyControllerTests: QuickSpec {
    override func spec() {
        describe("MyControllerTests") {
            testRail(12345, 22222, 33333) { // Add this new custom context
                context("when creating it") {
                    let sut = "short string"
                    it("no output value") {
                        expect(sut).to(equal("short string")
                    }
                }
            }
        }
    }

```

It will generate test with the following name:
`MyControllerTests__C12345_C22222_C33333__when_creating_it__no_output_value`

And this test will be picked up by swiftrail and report it to testrail for the linked testrail cases!

### Report

When running report you additionaly have to pass location of the test_reports, and if you want strict mode
- `--test-reports=''`
- `--strict` (default is `false`)

To be able to report the results of the tests, you need to first generate xml junit reports. Once you have those, running
```
swiftrail report --test-reports='path/to/test/reports' --run_id:123 (all the other options should also be included)
```
will report the results to TestRail. Dependent on success/failure the tests on TestRail will be marked accordingly.


If the strict mode is enabled, the upload will fail if you have test cases that are not present in the test run.

### Coverage

When running coverage you additionaly can pass output folder, where the report will be generated (if not passed it will print out to terminal)
- `--output_folder=''`


Coverage report will give you the percentage of test cases covered by your ui/unit/... tests.

```
swiftrail coverage --run_id:123 (all the other options should also be included)
```

### Lint

When running lint you additionaly can pass output folder, where the report will be generated (if not passed it will print out to terminal)
- `--output_folder=''`

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
