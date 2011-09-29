module Delayed
  class LimitedWorker < Worker
    ROUNDS = 100

    def start
      say "*** Starting limited job worker #{Delayed::Job.worker_name} at #{Time.now}"

      trap('TERM') { say 'Exiting...'; $exit = true }
      trap('INT')  { say 'Exiting...'; $exit = true }

      round = 0

      loop do
        result = nil

        realtime = Benchmark.realtime do
          say "Round #{round}..."

          result = Delayed::Job.work_off

          round += 1

          $exit = true if round >= ROUNDS
        end

        count = result.sum

        break if $exit

        if count.zero?
          sleep(SLEEP)
        else
          say "#{count} jobs processed at %.4f j/s, %d failed ..." % [count / realtime, result.last]
        end

        break if $exit
      end

    ensure
      Delayed::Job.clear_locks!
    end
  end
end
