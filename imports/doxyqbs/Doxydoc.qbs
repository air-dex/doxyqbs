/// @file Doxydoc.qbs
/// @brief Special product dedicated to generation
/// @author Romain Ducher <ducher.romain@gmail.com>
/// @section LICENCE
///
/// Copyright 2017 Romain Ducher
///
/// This file is part of doxyqbs.
///
/// Doxyqbs is free software: you can redistribute it and/or modify
/// it under the terms of the GNU Lesser General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Doxyqbs is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU Lesser General Public License for more details.
///
/// You should have received a copy of the GNU Lesser General Public License
/// along with doxyqbs. If not, see <http://www.gnu.org/licenses/>.
import qbs
import qbs.FileInfo

Product {
	Depends { name: 'doxyqbs' }
	type: [doxyqbs.GENERATED_DOC_FILETAG]	// doxygen_doc

	/// @brief Doxygen executable which will create documentation.
	property string doxygenExecutable: 'doxygen'

	/// @brief Doxygen configuration file.
	property string doxygenConfigFile: 'Doxyfile'

	doxyqbs.doxygenExecutable: doxygenExecutable

	// Tagging the configuration file
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
		fileTags: doxyqbs.DOXYFILE_FILETAG	// doxyfile
	}
}
