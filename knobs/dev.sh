if [ ! -d "./dist" ] ; then
    npm run build
fi

npm run dev-server
