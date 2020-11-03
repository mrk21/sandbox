package job

import "github.com/mrk21/sandbox/go_jobworker/pkg/jobque"

type Job interface {
	Perform(*jobque.Item) error
}
