/// @file Doxydoc.qbs
import qbs
import qbs.FileInfo

Product {
	Depends { name: 'doxyqbs' }
	type: [doxyqbs.GENERATED_DOC_FILETAG]

	/// @brief Doxygen executable which will create documentation.
	property string doxygenExecutable: 'doxygen'

	/// @brief Doxygen configuration file.
	property string doxygenConfigFile: 'Doxyfile'

	doxyqbs.doxygenExecutable: doxygenExecutable

	// Tagging the cnfiguration file
	Group {
		name: 'Doxygen configuration file'
		files: {
			if (FileInfo.isAbsolutePath(doxygenConfigFile)) {
				return doxygenConfigFile;
			}
			else {
				return FileInfo.joinPaths(project.sourceDirectory, doxygenConfigFile);
			}
		}
		fileTags: doxyqbs.DOXYFILE_FILETAG
	}
}
