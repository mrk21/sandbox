module Logging
  module Entity
    # type Base = {
    #   type: 'rails' | 'lograge';
    #   level: 'DEBUG' | 'INFO' | 'WARN' | 'ERROR' | 'FATAL' | 'ANY';
    #   time: string; // ISO 8601
    # };
    class LogBase
      TYPES = %i(rails lograge).freeze
      LEVELS = Logger::SEV_LABEL.freeze

      def self.fetch_type(value)
        Hash[*TYPES.map {|v| [v, v] }.flatten].fetch(value.to_s.intern)
      end

      def self.fetch_level(value)
        Hash[*LEVELS.map {|v| [v, v] }.flatten].fetch(value.to_s.upcase)
      end

      attr_reader :type
      attr_reader :time
      attr_reader :level

      def initialize(type:, level:, time:)
        @type = self.class.fetch_type(type)
        @time = case time
        when String
          Time.zone.parse(time).iso8601(6)
        when Integer, Float
          Time.zone.at(time).iso8601(6)
        when Time, ActiveSupport::TimeWithZone
          time.iso8601(6)
        else
          raise ArgumentError, "Invalid time: #{time.inspect}"
        end
        @level = self.class.fetch_level(level)
      end
    end

    # type RailsLog = LogBase & {
    #   sub_type: 'server' | 'job' | 'other';
    #   request_id: string | null; // for server
    #   job_name: string | null; // for active job
    #   job_id: string | null; // for active job
    #   message: string;
    #   tags: Array<string>;
    # };
    class RailsLog < LogBase
      SUB_TYPES = %i(server job other)

      def self.fetch_sub_type(value)
        Hash[*SUB_TYPES.map {|v| [v, v] }.flatten].fetch(value.to_s.intern)
      end

      attr_accessor :sub_type
      attr_accessor :tags
      attr_accessor :request_id
      attr_accessor :job_name
      attr_accessor :job_id
      attr_accessor :message

      def initialize(time:, level:, message:, tags:)
        super(type: :rails, time: time, level: level)
        @sub_type = nil
        @tags = tags
        @request_id = nil
        @job_name = nil
        @job_id = nil
        @message = message

        case @tags[0]
        when 'Server'
          @sub_type = self.class.fetch_sub_type(:server)
          @request_id = @tags[1]
        when 'ActiveJob'
          @sub_type = self.class.fetch_sub_type(:job)
          if @tags.size >= 3
            @job_name = @tags[1]
            @job_id = @tags[2]
          end
        when 'Sidekiq'
          @sub_type = self.class.fetch_sub_type(:job)
        else
          @sub_type = self.class.fetch_sub_type(:other)
        end
      end
    end

    # type LogrageAppendedLog = LogBase & {
    #   request_id: string;
    #   ip: string;
    #   referer: string;
    #   user_agent: string;
    #   params: { [key: string]: string }; // Hash
    #   exception: [string, string] | null;
    #   exception_backtrace: string[] | null;
    # };
    class LogrageAppendedLog < LogBase
      attr_reader :request_id
      attr_reader :ip
      attr_reader :referer
      attr_reader :user_agent
      attr_reader :params
      attr_reader :exception
      attr_reader :exception_backtrace

      def initialize(
        time:,
        level:, 
        request_id:,
        ip:,
        referer:,
        user_agent:,
        params:,
        exception: nil,
        exception_backtrace: nil
      )
        super(type: :lograge, time: time, level: level)
        @request_id = request_id
        @ip = ip
        @referer = referer
        @user_agent = user_agent
        @params = params
        @exception = exception
        @exception_backtrace = exception_backtrace
      end
    end
  end
end
