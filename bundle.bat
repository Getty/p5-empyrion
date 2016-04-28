@ECHO ON

pp -I "lib" --output="EmpyrionBlueprint.exe" --compile --execute --compress 9 --module="Text::LineFold" --module="Unicode::GCString" --bundle "bin\\empyrion_blueprint" --xargs="--from t\\game_blueprints\\BA_Starter_Tier1.epb"
