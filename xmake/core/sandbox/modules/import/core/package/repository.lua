--!The Make-like Build Utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2017, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        repository.lua
--

-- define module
local sandbox_core_package_repository = sandbox_core_package_repository or {}

-- load modules
local repository    = require("package/repository")
local raise         = require("sandbox/modules/raise")

-- get repository url from the given name
function sandbox_core_package_repository.get(name, global)
end

-- add repository url to the given name
function sandbox_core_package_repository.add(name, url, global)
end

-- set repository url to the given name
function sandbox_core_package_repository.set(name, url, global)
end

-- remove repository from gobal or local directory
function sandbox_core_package_repository.remove(name, global)
end

-- get all repository url list from global or local directory
function sandbox_core_package_repository.list(global)
end

-- return module
return sandbox_core_package_repository