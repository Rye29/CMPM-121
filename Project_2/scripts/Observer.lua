
ObserverClass = {}
SubjectClass = {}

function ObserverClass:new()
  local observerClass = {}

  observerClass.won = false

  setmetatable(observerClass, {__index = ObserverClass})

  return observerClass
end
function ObserverClass:reset()
  self.won = false
  return
end
function SubjectClass:new()
  local subjectClass = {}
  setmetatable(subjectClass, {__index = SubjectClass})
  subjectClass.observers = {}
  return subjectClass
end

function SubjectClass:subscribe(observator)
  table.insert(self.observers, observator)
  return
end

function SubjectClass:notifyWin(observator)
  --win notification
  observator.won = true
  return
end