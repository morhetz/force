UserEditFormView = require '../user_edit/view'
template = -> require('./template.jade') arguments...

module.exports = class AdvancedCollectorSettingsFormView extends UserEditFormView
  template: -> template arguments...
