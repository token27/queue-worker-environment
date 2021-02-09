<?php

namespace App\Shell\Task;

#
use Cake\Console\ConsoleIo;
use Cake\Console\Shell;
use Cake\ORM\Locator\LocatorInterface;
#
use Queued\Shell\Task\QueuedTask;
use Queued\Shell\Task\AddInterface;
use InvalidArgumentException;

/**
 * A Simple QueuedTask example that runs for a while and updates the progress field.
 */
class QueuedSimpleProgressExampleTask extends QueuedTask implements AddInterface {

    /**
     * Timeout for run, after which the Task is reassigned to a new worker.
     *
     * @var int
     */
    public $timeout = 120;

    /**
     * @param \Cake\Console\ConsoleIo|null $io IO
     * @param \Cake\ORM\Locator\LocatorInterface|null $locator
     */
    public function __construct(?ConsoleIo $io = null, ?LocatorInterface $locator = null) {
        parent::__construct($io, $locator);
    }

    /**
     * Example add functionality.
     * Will create one example job in the queue, which later will be executed using run();
     *
     * To invoke from CLI execute:
     * - bin/cake queued add SimpleProgressExample
     *
     * @return void
     */
    public function add() {
        $this->out('CakePHP Queued Simple Progress Example task.');
        $this->hr();
        $this->out('This is a very simple but long running example of a QueuedTask.');
        $this->out('I will now add the Job into the Queue.');
        $this->out('This job will need at least 2 minutes to complete.');
        $this->out(' ');
        $this->out('To run a Worker use:');
        $this->out('    bin/cake queued_worker run');
        $this->out(' ');
        $this->out('You can find the sourcecode of this task in:');
        $this->out(__FILE__);
        $this->out(' ');

        $additional_data = [
            'duration' => 1 * MINUTE,
        ];
        $this->QueuedTasks->addQueuedTask('SimpleProgressExample', $additional_data);
        $this->success('OK, job created, now run the worker');
    }

    /**
     * Example run function.
     * This function is executed, when a worker is executing a task.
     * The return parameter will determine, if the task will be marked completed, or be requeued.
     *
     * Defaults to 120 seconds
     *
     * @param string $queuedTaskId The id of the QueuedTask entity
     * @param array $additional_data The array passed to QueuedTasksTable::addQueuedTask()
     * @return void
     */
    public function run(string $queuedTaskId, array $additional_data): void {
        $this->hr();
        $this->out('CakePHP Queued Simple Progress Example task.');
        $seconds = !empty($additional_data['duration']) ? (int) $additional_data['duration'] : 2 * MINUTE;

        $this->out('A total of ' . $seconds . ' seconds need to pass...');
        for ($i = 0; $i < $seconds; $i++) {
            sleep(1);
            $this->QueuedTasks->updateProgress($queuedTaskId, ($i + 1) / $seconds, 'Status Test ' . ($i + 1) . 's');
        }
        $this->QueuedTasks->updateProgress($queuedTaskId, 1, 'Status Test Done');

        $this->hr();
        $this->success(' -> Success, the Simple Progress Example Job was run. <-');
    }

}
