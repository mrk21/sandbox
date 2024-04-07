module Logging
  module DockerLog
    def self.io_list
      result = [$stdout]
      result << IO.new(IO.sysopen('/proc/1/fd/1','w'),'w') if realpath('/dev/stdout') != realpath('/proc/1/fd/1')
      result
    end

    def self.realpath(path)
      loop do
        begin
          path = File.readlink(path)
        rescue Errno::EINVAL, Errno::ENOENT
          break
        end
      end
      path
    end
  end
end
