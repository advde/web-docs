#!/bin/bash


ROOT=$PWD

WORKSPACE=site-template
RAWDOCS=site-raw-docs

clean()
{
    cd $ROOT
    rm -Rf .git/modules/*
    git submodule deinit --all -f
    git rm -rf --cached $WORKSPACE/themes/hugo-theme-docport
    git rm -rf --cached $RAWDOCS
    rm .gitmodules
    rm -rf $WORKSPACE
    rm -rf $RAWDOCS
}


init()
{
    clean

    rm -r $WORKSPACE
    hugo new site $WORKSPACE
    git submodule add -b hugo-theme-docport https://github.com/advde/web-hugo-themes.git $WORKSPACE/themes/hugo-theme-docport
    git submodule add -b web-docs https://github.com/advde/docs-public.git $RAWDOCS
    #cp -R $WORKSPACE/themes/hugo-theme-docport/exampleSite/* $WORKSPACE
}

clean_workspace()
{
    rm -rf $WORKSPACE/archetypes
    rm -rf $WORKSPACE/data
    rm -rf $WORKSPACE/layouts
    rm -rf $WORKSPACE/static
    rm -rf $WORKSPACE/public
    rm -rf $WORKSPACE/resources
    rm -rf $WORKSPACE/*.toml
    rm -rf $WORKSPACE/content
}

sample()
{
    clean_workspace
    cp -R $WORKSPACE/themes/hugo-theme-docport/exampleSite/* $WORKSPACE
    cd $WORKSPACE
    #hugo server --theme=hugo-theme-docport --buildDrafts
    hugo server
    cd $ROOT
}

test()
{
    clean_workspace
    cp -R $RAWDOCS/* $WORKSPACE
    cd $WORKSPACE
    #hugo server --theme=hugo-theme-docport --buildDrafts
    hugo server
    cd $ROOT
}


dist()
{

    clean_workspace
    cp -R $RAWDOCS/* $WORKSPACE

    rm -rf $WORKSPACE/public
    cd $WORKSPACE

    #hugo --theme=hugo-theme-docport --baseUrl="https://docs.advde.com/"
    hugo --baseUrl="https://docs.advde.com/"
    cd ..
    rm docs -rf
    cp -r $WORKSPACE/public docs
    cp CNAME docs
}



usage()
{
    echo "./build.sh init"
    echo "./build.sh clean"
    echo "./build.sh dist"
    echo "./build.sh test"
    echo "./build.sh sample"
}

if [ -n "$1" ]; then
    if [ "$1" = "init" ]; then
        echo "init...."
        init
    elif [ "$1" = "dist" ]; then
        echo "dist"
        dist
    elif [ "$1" = "clean" ]; then
        echo "clean..."
        clean
    elif [ "$1" = "test" ]; then
        echo "test"
        test
    elif [ "$1" = "sample" ]; then
        echo "sample"
        sample
    else
        echo "unknown arg"
        usage
    fi

else
    echo "no arguments.."
    usage
    echo $ROOT
fi

