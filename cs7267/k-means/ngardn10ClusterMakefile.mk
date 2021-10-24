SHELL := /bin/bash
build:
	# compile into executable, stored in 'dist' folder
	( \
		python3 -m venv .env; \
		source .env/bin/activate; \
		pip install -r requirements.txt; \
		pyinstaller -F ngardn10ClusterBasic.py; \
		cp ./dist/ngardn10ClusterBasic ngardn10ClusterBasic; \
	)

run:
	# kmtest non normalized
	./ngardn10ClusterBasic -i kmtest.csv -K 3

	# kmtest normalized
	./ngardn10ClusterBasic -i kmtest.csv -K 3 -n z

	# mesocyclone non normalized
	./ngardn10ClusterBasic -i mesocyclone.csv -K 2

	# mesocyclone normalized
	./ngardn10ClusterBasic -i mesocyclone.csv -K 2 -n z

run_py:
	# run with python
	( \
		source .env/bin/activate; \
		python ngardn10ClusterBasic.py -i kmtest.csv -K 3; \
		python ngardn10ClusterBasic.py -i kmtest.csv -K 3 -n z; \
		python ngardn10ClusterBasic.py -i mesocyclone.csv -K 2; \
		python ngardn10ClusterBasic.py -i mesocyclone.csv -K 2 -n z ; \
	)

clean:
	-rm -rf .env
	-rm -rf build
	-rm -rf dist
	-rm ngardn10ClusterBasic
	-rm ngardn10ClusterBasic.spec
	-mkdir results
	-mv ./*.csv results
	-rm -rf results