-- HTML preview plugin for yazi
-- Renders HTML to text using w3m

local M = {}

function M:peek(job)
    local cmd = "w3m -dump -T text/html " .. ya.quote(tostring(job.file.url))

    local child, err = Command("sh")
        :args({ "-c", cmd })
        :stdout(Command.PIPED)
        :stderr(Command.NULL)
        :spawn()

    if not child then
        ya.err("html-preview: spawn failed: " .. tostring(err))
        return
    end

    local output, err = child:wait_with_output()
    if not output or not output.stdout or output.stdout == "" then
        ya.err("html-preview: no output")
        return
    end

    -- Split into lines and apply skip for scrolling
    local lines = {}
    for line in output.stdout:gmatch("[^\n]*") do
        table.insert(lines, line)
    end

    local skip = job.skip or 0
    local visible = {}
    for i = skip + 1, math.min(skip + job.area.h, #lines) do
        if lines[i] then
            table.insert(visible, lines[i])
        end
    end

    ya.preview_widget(job, ui.Text(table.concat(visible, "\n")):area(job.area))
end

function M:seek(job, units)
    local h = cx.active.current.hovered
    if h then
        local skip = job.skip or 0
        ya.manager_emit("peek", {
            math.max(0, skip + units),
            only_if = tostring(h.url),
        })
    end
end

return M
