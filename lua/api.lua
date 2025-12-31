local api = {}

api.objects = {}

function api.add(obj)
  api.objects[#api.objects + 1] = obj
end

function api.export()
  return api.objects
end

return api
