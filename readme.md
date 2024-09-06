# Export the current Conda environment to a YAML file

1. Open your terminal.  
2. Navigate to the directory where you want to save the environment.yml file.
3. Run the following command to export the current environment:

   ```bash
   conda env export --no-builds > environment.yml
   ```

   This command will create a file named `environment.yml` in the current directory, listing all the packages and their versions in your Conda environment.

4. To recreate the environment from the YAML file, use the following command:

   ```bash
   conda env create -f environment.yml
   ```

   This command will create a new environment with all the packages and versions specified in the `environment.yml` file.

5. If you want to update an existing environment using the YAML file instead of creating a new one, use the following command:

   ```bash
   conda env update --file environment.yml --prune
   ```

   This command will update the current environment with the packages specified in the `environment.yml` file. The `--prune` option will remove any dependencies that are no longer required.

6. If you want to clone a specific repository from GitHub, use the following command:

   ```bash
   git clone https://github.com/markmokhk/btman.git
   ```

   This command will clone the "btman" repository from the GitHub user "markmokhk" into a new directory in your current location.

7. After cloning, navigate into the newly created directory:

   ```bash
   cd btman
   ```

   You can now work with the cloned repository and use the environment.yml file if it's included in the project.

8. To update and push changes back to the GitHub repository (markmokhk/btman.git) using a public key, follow these steps:

   a. First, ensure your changes are staged:

      ```bash
      git add .
      ```

   b. Commit your changes with a meaningful message:

      ```bash
      git commit -m "Your commit message here"
      ```

   c. Push your changes to the remote repository:

      ```bash
      git push
      # OR
      git push -u up main
      # OR
      git push git@github.com:markmokhk/btman.git main
      ```


