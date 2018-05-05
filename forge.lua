
variant = variant or 'debug';

local forge = require( 'forge' ):load( variant );

local toolset = forge.Toolset 'cc_${platform}_${architecture}' {
    platform = operating_system();
    bin = root( ('%s/bin'):format(variant) );
    lib = root( ('%s/lib'):format(variant) );
    obj = root( ('%s/obj'):format(variant) );
    include_directories = {
        root();
    };
    library_directories = {
        root( ('%s/lib'):format(variant) );
    };
    visual_studio = {
        sln = root( 'lua.sln' );
    };
    xcode = {
        xcodeproj = root( 'lua.xcodeproj' );
    };

    architecture = 'x86-64';
    assertions = variant ~= 'shipping';
    debug = variant ~= 'shipping';
    debuggable = variant ~= 'shipping';
    exceptions = true;
    fast_floating_point = variant ~= 'debug';
    incremental_linking = variant == 'debug';
    link_time_code_generation = variant == 'shipping';
    minimal_rebuild = variant == 'debug';
    optimization = variant ~= 'debug';
    run_time_checks = variant == 'debug';
    runtime_library = variant == 'debug' and 'static_debug' or 'static_release';
    run_time_type_info = true;
    stack_size = 1048576;
    standard = 'c++11';
    string_pooling = variant == 'shipping';
    strip = false;
    warning_level = 3;
    warnings_as_errors = true;
};

-- Bump the C++ standard to c++14 when building on Windows as that is the 
-- closest standard supported by Microsoft Visual C++.
if toolset.platform == 'windows' then
    toolset.standard = 'c++14';
end

toolset:install( 'forge.cc' );

toolset:all {
    'src/all';
};

buildfile 'lua.forge';
