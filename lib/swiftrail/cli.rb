require 'thor'
require 'json'
require 'swiftrail'
require 'swiftrail/config/reader'

module Swiftrail
  class Cli < Thor
    private

    def self.defaults
      @defaults ||= Config::Reader.new.defaults
    end

    public

    class_option :test_classes, type: :string, default: defaults['test_classes'], desc: 'Regex to match your tests.'
    class_option :test_rail_username, type: :string, default: defaults['test_rail_username'], desc: 'Username for your test rail account.'
    class_option :test_rail_password, type: :string, default: defaults['test_rail_password'], desc: 'Password for your test rail account.'
    class_option :test_rail_url, type: :string, default: defaults['test_rail_url'], desc: 'Base url for your testrail account.'
    class_option :run_id, type: :string, default: defaults['run_id'], desc: 'Test Rail run id for which you\'re executing an action'

    desc 'report', 'Reports success/failure to test rail, based on the results of your tests'
    method_option :test_reports, type: :string, aliases: '-reports', default: defaults['reports'], desc: 'Regex to match your junit report files.'
    method_option :strict, type: :boolean, aliases: '-strict', default: defaults['reports'], desc: 'Fail if there you are trying to report missing test case id'
    method_option :dry_run, type: :boolean, default: defaults['dry_run'], desc: 'During dry run, results will be printed out instead of sent to test rail'
    def report
      if swiftrail_reporter.report_results(options[:run_id], options[:dry_run])
        puts 'Successfully reported the results'
      else
        puts 'There was an issue while reporting the results'
      end
    end

    desc 'coverage', 'Reports coverage of all the tests on testrail account'
    method_option :output_folder, type: :string, desc: 'Ouptut folder for your results'
    def coverage
      results = swiftrail_coverage.coverage_report(options[:run_id])
      if options['output_folder'].nil?
        puts(JSON.pretty_generate(results))
      else
        write(results, File.join(options['output_folder'], 'coverage.swiftrail'))
      end

    end

    desc 'lint', 'Reports case ids that are missing on testrail account'
    method_option :output_folder, type: :string, desc: 'Ouptut folder for your results'
    def lint
      results = swiftrail_lint.lint_report(options[:run_id])
      if options['output_folder'].nil?
        puts(JSON.pretty_generate(results))
      else
        write(results, File.join(options['output_folder'], 'lint.swiftrail'))
      end
    end

    private

    def swiftrail_reporter
      Swiftrail::Testrail::Reporter.new(
        [options['test_reports']],
        [options['test_classes']],
        options['test_rail_username'],
        options['test_rail_password'],
        options['test_rail_url'],
        options['strict']
      )
    end

    def swiftrail_coverage
      Swiftrail::Testrail::Coverage.new(
        [options['test_classes']],
        options['test_rail_username'],
        options['test_rail_password'],
        options['test_rail_url']
      )
    end

    def swiftrail_lint
      Swiftrail::Testrail::Lint.new(
        [options['test_classes']],
        options['test_rail_username'],
        options['test_rail_password'],
        options['test_rail_url']
      )
    end

    def write(hash, file)
      File.open(file,"w") do |f|
        f.write(JSON.pretty_generate(hash))
      end
    end
  end
end
