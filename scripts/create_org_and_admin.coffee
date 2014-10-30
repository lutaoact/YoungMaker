'use strict'
require '../server/common/init'

if process.argv.length < 4
  console.log "注意看用法："
  console.log "Usage: coffee build_info_for_org.coffee [uniqueName] [name]"
  process.exit 1

uniqueName = process.argv[2]
name       = process.argv[3]

Organization = _u.getModel 'organization'
User = _u.getModel 'user'

tmpResult = {}
organization = uniqueName: uniqueName, name: name, type: 'colledge'

Organization.findOneQ uniqueName: uniqueName
.then (org) ->
  if org?
    return org
  else
    return Organization.createQ organization #新增organization
.then (org) ->
  tmpResult.org = org

  admin =
    username: "admin_#{uniqueName}"
    password: "admin_#{uniqueName}"
    name: "#{name}管理员"
    role: 'admin'
    orgId: tmpResult.org._id

  User.createQ admin
.then (admin) ->
  tmpResult.admin = admin
  console.log tmpResult
, (err) ->
  console.log err
