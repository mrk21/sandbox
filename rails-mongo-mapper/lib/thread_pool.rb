class ThreadPool
  def initialize(n)
    @n = n
  end

  def start
    @queue = Thread::SizedQueue.new(@n)
    @threads = @n.times.map do
      Thread.new { self.exec }
    end
  end

  def stop
    @queue.close
    @threads.each(&:join)
  end

  def perform(&block)
    @queue.push(block)
  end

  def size
    @queue.size
  end

  private

  def exec
    while task = @queue.pop
      task.call
    end
  end
end
