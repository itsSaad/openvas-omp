
    # The client uses the delete_task command to delete an existing task,
    # including all reports associated with the task. 
    # 
    def task_delete(task_id) 
      task = @tasks[task_id.to_i]
      if not task
        raise OMPError.new("Invalid task id.")
      end
      req = xml_attrs("delete_task",{"task_id" => task["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
        task_get_all
        return status_text
      rescue 
        raise OMPResponseError
      end
    end

    # In short: Get all tasks.
    #
    # The client uses the get_tasks command to get task information. 
    # 
    def task_get_all()
      begin
        status, status_text, resp = omp_request_xml("<get_tasks/>")
        
        list = Array.new
        resp.elements.each('//get_tasks_response/task') do |task|
          td = Hash.new
          td["id"] = task.attributes["id"]
          td["name"] = task.elements["name"].text
          td["comment"] = task.elements["comment"].text
          td["status"] = task.elements["status"].text
          td["progress"] = task.elements["progress"].text
          list.push td	
        end
        @tasks = list
        return list
      rescue
        raise OMPResponseError
      end
    end

    # In short: Manually start an existing task.
    #
    # The client uses the start_task command to manually start an existing
    # task.
    #
    def task_start(task_id)
      task = @tasks[task_id.to_i]
      if not task
        raise OMPError.new("Invalid task id.")
      end
      req = xml_attrs("start_task",{"task_id" => task["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
        return status_text
      rescue 
        raise OMPResponseError
      end
    end

    # In short: Stop a running task.
    #
    # The client uses the stop_task command to manually stop a running
    # task.
    #
    def task_stop(task_id) 
      task = @tasks[task_id.to_i]
      if not task
        raise OMPError.new("Invalid task id.")
      end
      req = xml_attrs("stop_task",{"task_id" => task["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
        return status_text
      rescue 
        raise OMPResponseError
      end
    end 

    # In short: Pause a running task.
    #
    # The client uses the pause_task command to manually pause a running
    # task.
    #
    def task_pause(task_id) 
      task = @tasks[task_id.to_i]
      if not task
        raise OMPError.new("Invalid task id.")
      end
      req = xml_attrs("pause_task",{"task_id" => task["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
        return status_text
      rescue 
        raise OMPResponseError
      end
    end

    # In short: Resume task if stopped, else start task.
    #
    # The client uses the resume_or_start_task command to manually start
    # an existing task, ensuring that the task will resume from its
    # previous position if the task is in the Stopped state.
    # 
    def task_resume_or_start(task_id) 
      task = @tasks[task_id.to_i]
      if not task
        raise OMPError.new("Invalid task id.")
      end
      req = xml_attrs("resume_or_start_task",{"task_id" => task["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
        return status_text
      rescue 
        raise OMPResponseError
      end
    end

    # In short: Resume a puased task
    #
    # The client uses the resume_paused_task command to manually resume
    # a paused task.
    # 
    def task_resume_paused(task_id) 
      task = @tasks[task_id.to_i]
      if not task
        raise OMPError.new("Invalid task id.")
      end
      req = xml_attrs("resume_paused_task",{"task_id" => task["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
        return status_text
      rescue 
        raise OMPResponseError
      end
    end

  #--------------------------
  # Config Functions
  #--------------------------
    # OMP - get configs and returns hash as response
    # hash[config_id]=config_name
    #
    # Usage:
    #
    # array_of_hashes=ov.config_get_all()
    # 
    def config_get_all()
      begin
        status, status_text, resp = omp_request_xml("<get_configs/>")

        list = Array.new
        resp.elements.each('//get_configs_response/config') do |config|
          c = Hash.new
          c["id"] = config.attributes["id"]
          c["name"] = config.elements["name"].text
          list.push c
        end
        @configs = list
        return list
      rescue 
        raise OMPResponseError
      end
    end	


  #--------------------------
  # Format Functions
  #--------------------------
    # Get a list of report formats
    def format_get_all()
      begin
        status, status_text, resp = omp_request_xml("<get_report_formats/>")
        if @debug then print resp end
        
        list = Array.new
        resp.elements.each('//get_report_formats_response/report_format') do |report|
          td = Hash.new
          td["id"] = report.attributes["id"]
          td["name"] = report.elements["name"].text
          td["extension"] = report.elements["extension"].text
          td["summary"] = report.elements["summary"].text
          list.push td	
        end
        @formats = list
        return list
      rescue
        raise OMPResponseError
      end
    end


  #--------------------------
  # Report Functions
  #--------------------------
    # Get a list of reports
    def report_get_all()
      begin
        status, status_text, resp = omp_request_xml("<get_reports/>")
        
        list = Array.new
        resp.elements.each('//get_reports_response/report') do |report|
          td = Hash.new
          td["id"] = report.attributes["id"]
          td["task"] = report.elements["report/task/name"].text
          td["start_time"] = report.elements["report/scan_start"].text
          td["stop_time"] = report.elements["report/scan_end"].text
          list.push td	
        end
        @reports = list
        return list
      rescue
        raise OMPResponseError
      end
    end

    def report_delete(report_id) 
      report = @reports[report_id.to_i]
      if not report
        raise OMPError.new("Invalid report id.")
      end
      req = xml_attrs("delete_report",{"report_id" => report["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
        report_get_all
        return status_text
      rescue 
        raise OMPResponseError
      end
    end

    # Get a report by id. Must also specify the format_id
    def report_get_by_id(report_id, format_id)
      report = @reports[report_id.to_i]
      if not report
        raise OMPError.new("Invalid report id.")
      end

      format = @formats[format_id.to_i]
      if not format
        raise OMPError.new("Invalid format id.")
      end

      req = xml_attrs("get_reports", {"report_id"=>report["id"], "format_id"=>format["id"]})
      begin
        status, status_text, resp = omp_request_xml(req)
      rescue
        raise OMPResponseError
      end

      if status == "404"
        raise OMPError.new(status_text)
      end

      content_type = resp.elements["report"].attributes["content_type"]
      report = resp.elements["report"].to_s

      if report == nil
        raise OMPError.new("The report is empty.")
      end

      # XML reports are in XML format, everything else is base64 encoded.
      if content_type == "text/xml"
        return report
      else
        return Base64.decode64(report)
      end
    end

    end
end
