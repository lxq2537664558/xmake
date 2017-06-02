--!The Make-like install Utility based on Lua
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
-- @file        install.lua
--

-- imports
import("core.base.option")
import("build")

-- install for xmake file
function _install_for_xmakefile(package, installfile)

    -- package to install directory
    os.vrun("xmake p -o %s", package:installdir())

    -- ok
    return true
end

-- install for makefile
function _install_for_makefile(package, installfile)

    -- ok
    return true
end

-- install for configure
function _install_for_configure(package, installfile)

    -- install it
    return _install_for_makefile(package)
end

-- install for cmakelist
function _install_for_cmakelists(package, installfile)

    -- install it
    return _install_for_makefile(package)
end

-- install for *.sln
function _install_for_sln(package, installfile)
    return false
end

-- on install the given package
function _on_install_package(package)

    -- TODO *.vcproj, premake.lua, scons, autogen.sh, Makefile.am, ...
    -- init install scripts
    local installscripts =
    {
        {"xmake.lua",       _install_for_xmakefile    }
    ,   {"*.sln",           _install_for_sln          }
    ,   {"CMakeLists.txt",  _install_for_cmakelists   }
    ,   {"configure",       _install_for_configure    }
    ,   {"[mM]akefile",     _install_for_makefile     }
    }

    -- attempt to install it
    for _, installscript in pairs(installscripts) do

        -- save the current directory 
        local oldir = os.curdir()

        -- try installing 
        local ok = try
        {
            function ()

                -- attempt to install it if file exists
                local files = os.files(installscript[1])
                if #files > 0 then
                    return installscript[2](package, files[1])
                end
            end,

            catch
            {
                function (errors)

                    -- trace verbose info
                    if errors then
                        vprint(errors)
                    end
                end
            }
        }

        -- restore directory
        os.cd(oldir)

        -- ok?
        if ok then return end
    end

    -- failed
    raise("attempt to install package %s failed!", package:name())
end

-- install the given package
function main(package)

    -- skip phony package without urls
    if #package:urls() == 0 then
        return
    end

    -- get working directory of this package
    local workdir = package:cachedir()

    -- enter source files directory
    local oldir = nil
    for _, srcdir in ipairs(os.dirs(path.join(workdir, "source", "*"))) do
        oldir = os.cd(srcdir)
        break
    end

    -- trace
    cprintf("${yellow}  => ${clear}installing %s-%s .. ", package:name(), package:version_str())
    if option.get("verbose") then
        print("")
    end

    -- install it
    try
    {
        function ()

            -- the package scripts
            local scripts =
            {
                package:script("install_before") 
            ,   package:script("install", _on_install_package)
            ,   package:script("install_after") 
            }

            -- create the install task
            local installtask = function () 

                -- build it
                build(package)

                -- install it
                for i = 1, 3 do
                    local script = scripts[i]
                    if script ~= nil then
                        script(package)
                    end
                end
            end

            -- install package
            if option.get("verbose") then
                installtask()
            else
                process.asyncrun(installtask)
            end

            -- trace
            cprint("${green}ok")
        end,

        catch
        {
            function (errors)

                -- verbose?
                if option.get("verbose") and errors then
                    cprint("${bright red}error: ${clear}%s", errors)
                end

                -- trace
                cprint("${red}failed")

                -- failed
                raise("install failed!")
            end
        }
    }

    -- leave source codes directory
    os.cd(oldir)
end
