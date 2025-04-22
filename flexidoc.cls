%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FlexiDoc LaTeX Class
% File: flexidoc.cls
% Date: 2024/12/19
% Version: 2.7
%
% FlexiDoc is a flexible LaTeX class that provides a consistent layout
% for documents while offering key-value options for:
%   - Base class selection: base=article (default), report, or book.
%   - Font size: fontsize=10pt (default), 11pt, or 12pt.
%   - Margin settings: margins=normal (default), narrow, or wide.
%   - Document language: lang=english (default), german, de-cH, etc.
%
% Additionally, a \subtitle command is provided to include a subtitle
% in the title page.
%
% The class loads commonly used packages for input encoding, typography,
% page geometry, headers/footers, hyperlinks, section formatting, and
% bibliography support (using biblatex with an author-year style).
%
% The title page layout is customized using the standard LaTeX commands
% (\title, \subtitle, \author, \date) without introducing excessive
% wrapper commands.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{flexidoc}[2024/12/19 FlexiDoc LaTeX Class version 2.7]

% --------------------------------------------------------------------
% Use kvoptions for key–value interface.
% --------------------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family=flexidoc,
  prefix=flexidoc@
}

% Define key options with defaults:
\DeclareStringOption[article]{base}
\DeclareStringOption[10pt]{fontsize}
\DeclareStringOption[normal]{margins}
\DeclareStringOption[english]{lang}
\ProcessKeyvalOptions*

% --------------------------------------------------------------------
% Process the Margins Option
% --------------------------------------------------------------------
\RequirePackage{ifthen}
\ifthenelse{\equal{\flexidoc@margins}{normal}}{%
   \renewcommand{\flexidoc@margins}{a4paper, left=3cm, right=3cm, top=2.5cm, bottom=2.5cm}%
}{%
\ifthenelse{\equal{\flexidoc@margins}{narrow}}{%
   \renewcommand{\flexidoc@margins}{a4paper, left=2.5cm, right=2.5cm, top=2cm, bottom=2cm}%
}{%
\ifthenelse{\equal{\flexidoc@margins}{wide}}{%
   \renewcommand{\flexidoc@margins}{a4paper, left=4cm, right=4cm, top=3cm, bottom=3cm}%
}{}
}%
}

% --------------------------------------------------------------------
% Load the Chosen Base Class
% --------------------------------------------------------------------
\LoadClass[\flexidoc@fontsize,a4paper]{\flexidoc@base}

% --------------------------------------------------------------------
% Input and Language Settings
% --------------------------------------------------------------------
\RequirePackage[utf8]{inputenc}       % For pdfLaTeX input encoding
\RequirePackage[T1]{fontenc}          % Output font encoding
\RequirePackage[provide=*,\flexidoc@lang]{babel}   % Set document language

% --------------------------------------------------------------------
% Font and Typography Settings
% --------------------------------------------------------------------
\RequirePackage{helvet}               % Sans-serif (Helvetica)
\RequirePackage{mathptmx}             % Serif (Times)
\renewcommand{\sfdefault}{phv}         % Use Helvetica as default sans-serif font

\RequirePackage{microtype}            % Enhanced typography
\DisableLigatures{encoding = *, family = * }

% --------------------------------------------------------------------
% Page Layout
% --------------------------------------------------------------------
\RequirePackage{geometry}
\expandafter\geometry\expandafter{\flexidoc@margins}

\RequirePackage{setspace}
\onehalfspacing                     % One-and-a-half spacing

% --------------------------------------------------------------------
% Additional Utility Packages
% --------------------------------------------------------------------
\RequirePackage{lipsum}               % Dummy text for testing
\RequirePackage{amsmath,amssymb,amsthm} % Mathematics packages
\RequirePackage{csquotes}
\RequirePackage{array}
\RequirePackage{graphicx}
\RequirePackage{float}


% --------------------------------------------------------------------
% Hyperlinks and Colors
% --------------------------------------------------------------------
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    citecolor=TealBlue,
    urlcolor=TealBlue
}

% --------------------------------------------------------------------
% Section Title Formatting
% --------------------------------------------------------------------
\RequirePackage{titlesec}
\titleformat{\section}{\sffamily\Large\bfseries\raggedright}{\thesection}{1em}{}
\titleformat{\subsection}{\sffamily\large\bfseries\raggedright}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\sffamily\normalsize\bfseries\raggedright}{\thesubsubsection}{1em}{}

% --------------------------------------------------------------------
% List Customization
% --------------------------------------------------------------------
\RequirePackage{enumitem}

% --------------------------------------------------------------------
% Headers and Footers
% --------------------------------------------------------------------
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}   % Remove header rule
\renewcommand{\footrulewidth}{0pt}   % Remove footer rule
\fancyfoot[R]{\thepage}             % Page number on bottom right

% --------------------------------------------------------------------
% Bibliography with biblatex
% --------------------------------------------------------------------
\RequirePackage[backend=biber,style=authoryear]{biblatex}

% --------------------------------------------------------------------
% Additional Package: ragged2e
% --------------------------------------------------------------------
\RequirePackage{ragged2e}             % Provides \justifying

% --------------------------------------------------------------------
% Additional: Subtitle Command
% --------------------------------------------------------------------
% Define \subtitle to store a subtitle, and initialize \@subtitle.
\newcommand{\subtitle}[1]{\gdef\@subtitle{#1}}
\newcommand{\@subtitle}{} % Default empty subtitle

% --------------------------------------------------------------------
% Custom Title Page Definition
% --------------------------------------------------------------------
\makeatletter
\renewcommand{\maketitle}{
    \vspace*{-2em}
    \sffamily
    \raggedright
    {\Large\bfseries \@title \par}
    % If a subtitle was provided, print it.
    \ifx\@subtitle\@empty
      % Do nothing if subtitle is empty
    \else
      {\large \@subtitle \par}
    \fi
    \vspace{1em}
    {\footnotesize
        \@author \\
        \@date
    }
    \par\vspace{2em}
    \normalfont
    \normalsize
    \rmfamily
    \justifying
}
\makeatother

% --------------------------------------------------------------------
% End of Class Definition
% --------------------------------------------------------------------
% FlexiDoc is now ready for use. Enjoy your flexible and consistent document layout!
