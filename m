Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A23234B7B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 Jul 2020 21:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGaTMk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 31 Jul 2020 15:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgGaTMk (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 31 Jul 2020 15:12:40 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452E821744;
        Fri, 31 Jul 2020 19:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596222757;
        bh=JQdjcV+g3lPg+sFUpbqbC+RCUBmjMDgaqXfzg56QJk0=;
        h=From:To:Cc:Subject:Date:From;
        b=0sKUxT+HaCsgCXW/ABTbMfTNLpzKXhpfL9XFPuPo/MKbNIsISMxqcAmenHYKENk6/
         tBJB7HOxrTjoIuceycvtQXdwIh5NPQ7I9ijZ6TM631v9bGJNVnpBaJMlEi/WRFnigd
         X5hAxCY23iVHF14vYEBlV3m2WTpGl2IWUp1anhH8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Jes Sorensen <jsorensen@fb.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Chris Mason <clm@fb.com>, kernel-team@fb.com,
        Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils PATCH] Switch to MIT license
Date:   Fri, 31 Jul 2020 12:11:56 -0700
Message-Id: <20200731191156.22602-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This allows libfsverity to be used by software with other common
licenses, e.g. LGPL, MIT, BSD, and Apache 2.0.  It also avoids the
incompatibility that some people perceive between OpenSSL and the GPL.

See discussion at
https://lkml.kernel.org/linux-fscrypt/20200211000037.189180-1-Jes.Sorensen@gmail.com/T/#u

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .clang-format                  |   6 +-
 COPYING                        | 339 ---------------------------------
 LICENSE                        |  21 ++
 Makefile                       |   7 +-
 NEWS.md                        |   4 +
 README.md                      |   7 +-
 common/common_defs.h           |   6 +-
 common/libfsverity.h           |   6 +-
 lib/compute_digest.c           |   6 +-
 lib/hash_algs.c                |   6 +-
 lib/lib_private.h              |   6 +-
 lib/sign_digest.c              |   6 +-
 lib/utils.c                    |   6 +-
 programs/cmd_enable.c          |   6 +-
 programs/cmd_measure.c         |   6 +-
 programs/cmd_sign.c            |   6 +-
 programs/fsverity.c            |  18 +-
 programs/fsverity.h            |   6 +-
 programs/test_compute_digest.c |   6 +-
 programs/test_hash_algs.c      |   6 +-
 programs/test_sign_digest.c    |   6 +-
 programs/utils.c               |   6 +-
 programs/utils.h               |   6 +-
 scripts/do-release.sh          |   6 +-
 scripts/run-sparse.sh          |   6 +-
 scripts/run-tests.sh           |  17 +-
 26 files changed, 149 insertions(+), 378 deletions(-)
 delete mode 100644 COPYING
 create mode 100644 LICENSE

diff --git a/.clang-format b/.clang-format
index 2a21ac5..834d0a4 100644
--- a/.clang-format
+++ b/.clang-format
@@ -1,6 +1,10 @@
-# SPDX-License-Identifier: GPL-2.0-or-later
+# SPDX-License-Identifier: MIT
 # Copyright 2020 Google LLC
 #
+# Use of this source code is governed by an MIT-style
+# license that can be found in the LICENSE file or at
+# https://opensource.org/licenses/MIT.
+
 # Formatting settings to approximate the Linux kernel coding style.
 BasedOnStyle: LLVM
 AllowShortFunctionsOnASingleLine: false
diff --git a/COPYING b/COPYING
deleted file mode 100644
index d159169..0000000
--- a/COPYING
+++ /dev/null
@@ -1,339 +0,0 @@
-                    GNU GENERAL PUBLIC LICENSE
-                       Version 2, June 1991
-
- Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
- Everyone is permitted to copy and distribute verbatim copies
- of this license document, but changing it is not allowed.
-
-                            Preamble
-
-  The licenses for most software are designed to take away your
-freedom to share and change it.  By contrast, the GNU General Public
-License is intended to guarantee your freedom to share and change free
-software--to make sure the software is free for all its users.  This
-General Public License applies to most of the Free Software
-Foundation's software and to any other program whose authors commit to
-using it.  (Some other Free Software Foundation software is covered by
-the GNU Lesser General Public License instead.)  You can apply it to
-your programs, too.
-
-  When we speak of free software, we are referring to freedom, not
-price.  Our General Public Licenses are designed to make sure that you
-have the freedom to distribute copies of free software (and charge for
-this service if you wish), that you receive source code or can get it
-if you want it, that you can change the software or use pieces of it
-in new free programs; and that you know you can do these things.
-
-  To protect your rights, we need to make restrictions that forbid
-anyone to deny you these rights or to ask you to surrender the rights.
-These restrictions translate to certain responsibilities for you if you
-distribute copies of the software, or if you modify it.
-
-  For example, if you distribute copies of such a program, whether
-gratis or for a fee, you must give the recipients all the rights that
-you have.  You must make sure that they, too, receive or can get the
-source code.  And you must show them these terms so they know their
-rights.
-
-  We protect your rights with two steps: (1) copyright the software, and
-(2) offer you this license which gives you legal permission to copy,
-distribute and/or modify the software.
-
-  Also, for each author's protection and ours, we want to make certain
-that everyone understands that there is no warranty for this free
-software.  If the software is modified by someone else and passed on, we
-want its recipients to know that what they have is not the original, so
-that any problems introduced by others will not reflect on the original
-authors' reputations.
-
-  Finally, any free program is threatened constantly by software
-patents.  We wish to avoid the danger that redistributors of a free
-program will individually obtain patent licenses, in effect making the
-program proprietary.  To prevent this, we have made it clear that any
-patent must be licensed for everyone's free use or not licensed at all.
-
-  The precise terms and conditions for copying, distribution and
-modification follow.
-
-                    GNU GENERAL PUBLIC LICENSE
-   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
-
-  0. This License applies to any program or other work which contains
-a notice placed by the copyright holder saying it may be distributed
-under the terms of this General Public License.  The "Program", below,
-refers to any such program or work, and a "work based on the Program"
-means either the Program or any derivative work under copyright law:
-that is to say, a work containing the Program or a portion of it,
-either verbatim or with modifications and/or translated into another
-language.  (Hereinafter, translation is included without limitation in
-the term "modification".)  Each licensee is addressed as "you".
-
-Activities other than copying, distribution and modification are not
-covered by this License; they are outside its scope.  The act of
-running the Program is not restricted, and the output from the Program
-is covered only if its contents constitute a work based on the
-Program (independent of having been made by running the Program).
-Whether that is true depends on what the Program does.
-
-  1. You may copy and distribute verbatim copies of the Program's
-source code as you receive it, in any medium, provided that you
-conspicuously and appropriately publish on each copy an appropriate
-copyright notice and disclaimer of warranty; keep intact all the
-notices that refer to this License and to the absence of any warranty;
-and give any other recipients of the Program a copy of this License
-along with the Program.
-
-You may charge a fee for the physical act of transferring a copy, and
-you may at your option offer warranty protection in exchange for a fee.
-
-  2. You may modify your copy or copies of the Program or any portion
-of it, thus forming a work based on the Program, and copy and
-distribute such modifications or work under the terms of Section 1
-above, provided that you also meet all of these conditions:
-
-    a) You must cause the modified files to carry prominent notices
-    stating that you changed the files and the date of any change.
-
-    b) You must cause any work that you distribute or publish, that in
-    whole or in part contains or is derived from the Program or any
-    part thereof, to be licensed as a whole at no charge to all third
-    parties under the terms of this License.
-
-    c) If the modified program normally reads commands interactively
-    when run, you must cause it, when started running for such
-    interactive use in the most ordinary way, to print or display an
-    announcement including an appropriate copyright notice and a
-    notice that there is no warranty (or else, saying that you provide
-    a warranty) and that users may redistribute the program under
-    these conditions, and telling the user how to view a copy of this
-    License.  (Exception: if the Program itself is interactive but
-    does not normally print such an announcement, your work based on
-    the Program is not required to print an announcement.)
-
-These requirements apply to the modified work as a whole.  If
-identifiable sections of that work are not derived from the Program,
-and can be reasonably considered independent and separate works in
-themselves, then this License, and its terms, do not apply to those
-sections when you distribute them as separate works.  But when you
-distribute the same sections as part of a whole which is a work based
-on the Program, the distribution of the whole must be on the terms of
-this License, whose permissions for other licensees extend to the
-entire whole, and thus to each and every part regardless of who wrote it.
-
-Thus, it is not the intent of this section to claim rights or contest
-your rights to work written entirely by you; rather, the intent is to
-exercise the right to control the distribution of derivative or
-collective works based on the Program.
-
-In addition, mere aggregation of another work not based on the Program
-with the Program (or with a work based on the Program) on a volume of
-a storage or distribution medium does not bring the other work under
-the scope of this License.
-
-  3. You may copy and distribute the Program (or a work based on it,
-under Section 2) in object code or executable form under the terms of
-Sections 1 and 2 above provided that you also do one of the following:
-
-    a) Accompany it with the complete corresponding machine-readable
-    source code, which must be distributed under the terms of Sections
-    1 and 2 above on a medium customarily used for software interchange; or,
-
-    b) Accompany it with a written offer, valid for at least three
-    years, to give any third party, for a charge no more than your
-    cost of physically performing source distribution, a complete
-    machine-readable copy of the corresponding source code, to be
-    distributed under the terms of Sections 1 and 2 above on a medium
-    customarily used for software interchange; or,
-
-    c) Accompany it with the information you received as to the offer
-    to distribute corresponding source code.  (This alternative is
-    allowed only for noncommercial distribution and only if you
-    received the program in object code or executable form with such
-    an offer, in accord with Subsection b above.)
-
-The source code for a work means the preferred form of the work for
-making modifications to it.  For an executable work, complete source
-code means all the source code for all modules it contains, plus any
-associated interface definition files, plus the scripts used to
-control compilation and installation of the executable.  However, as a
-special exception, the source code distributed need not include
-anything that is normally distributed (in either source or binary
-form) with the major components (compiler, kernel, and so on) of the
-operating system on which the executable runs, unless that component
-itself accompanies the executable.
-
-If distribution of executable or object code is made by offering
-access to copy from a designated place, then offering equivalent
-access to copy the source code from the same place counts as
-distribution of the source code, even though third parties are not
-compelled to copy the source along with the object code.
-
-  4. You may not copy, modify, sublicense, or distribute the Program
-except as expressly provided under this License.  Any attempt
-otherwise to copy, modify, sublicense or distribute the Program is
-void, and will automatically terminate your rights under this License.
-However, parties who have received copies, or rights, from you under
-this License will not have their licenses terminated so long as such
-parties remain in full compliance.
-
-  5. You are not required to accept this License, since you have not
-signed it.  However, nothing else grants you permission to modify or
-distribute the Program or its derivative works.  These actions are
-prohibited by law if you do not accept this License.  Therefore, by
-modifying or distributing the Program (or any work based on the
-Program), you indicate your acceptance of this License to do so, and
-all its terms and conditions for copying, distributing or modifying
-the Program or works based on it.
-
-  6. Each time you redistribute the Program (or any work based on the
-Program), the recipient automatically receives a license from the
-original licensor to copy, distribute or modify the Program subject to
-these terms and conditions.  You may not impose any further
-restrictions on the recipients' exercise of the rights granted herein.
-You are not responsible for enforcing compliance by third parties to
-this License.
-
-  7. If, as a consequence of a court judgment or allegation of patent
-infringement or for any other reason (not limited to patent issues),
-conditions are imposed on you (whether by court order, agreement or
-otherwise) that contradict the conditions of this License, they do not
-excuse you from the conditions of this License.  If you cannot
-distribute so as to satisfy simultaneously your obligations under this
-License and any other pertinent obligations, then as a consequence you
-may not distribute the Program at all.  For example, if a patent
-license would not permit royalty-free redistribution of the Program by
-all those who receive copies directly or indirectly through you, then
-the only way you could satisfy both it and this License would be to
-refrain entirely from distribution of the Program.
-
-If any portion of this section is held invalid or unenforceable under
-any particular circumstance, the balance of the section is intended to
-apply and the section as a whole is intended to apply in other
-circumstances.
-
-It is not the purpose of this section to induce you to infringe any
-patents or other property right claims or to contest validity of any
-such claims; this section has the sole purpose of protecting the
-integrity of the free software distribution system, which is
-implemented by public license practices.  Many people have made
-generous contributions to the wide range of software distributed
-through that system in reliance on consistent application of that
-system; it is up to the author/donor to decide if he or she is willing
-to distribute software through any other system and a licensee cannot
-impose that choice.
-
-This section is intended to make thoroughly clear what is believed to
-be a consequence of the rest of this License.
-
-  8. If the distribution and/or use of the Program is restricted in
-certain countries either by patents or by copyrighted interfaces, the
-original copyright holder who places the Program under this License
-may add an explicit geographical distribution limitation excluding
-those countries, so that distribution is permitted only in or among
-countries not thus excluded.  In such case, this License incorporates
-the limitation as if written in the body of this License.
-
-  9. The Free Software Foundation may publish revised and/or new versions
-of the General Public License from time to time.  Such new versions will
-be similar in spirit to the present version, but may differ in detail to
-address new problems or concerns.
-
-Each version is given a distinguishing version number.  If the Program
-specifies a version number of this License which applies to it and "any
-later version", you have the option of following the terms and conditions
-either of that version or of any later version published by the Free
-Software Foundation.  If the Program does not specify a version number of
-this License, you may choose any version ever published by the Free Software
-Foundation.
-
-  10. If you wish to incorporate parts of the Program into other free
-programs whose distribution conditions are different, write to the author
-to ask for permission.  For software which is copyrighted by the Free
-Software Foundation, write to the Free Software Foundation; we sometimes
-make exceptions for this.  Our decision will be guided by the two goals
-of preserving the free status of all derivatives of our free software and
-of promoting the sharing and reuse of software generally.
-
-                            NO WARRANTY
-
-  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
-FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
-OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
-PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
-OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
-MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
-TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
-PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
-REPAIR OR CORRECTION.
-
-  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
-WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
-REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
-INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
-OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
-TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
-YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
-PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
-POSSIBILITY OF SUCH DAMAGES.
-
-                     END OF TERMS AND CONDITIONS
-
-            How to Apply These Terms to Your New Programs
-
-  If you develop a new program, and you want it to be of the greatest
-possible use to the public, the best way to achieve this is to make it
-free software which everyone can redistribute and change under these terms.
-
-  To do so, attach the following notices to the program.  It is safest
-to attach them to the start of each source file to most effectively
-convey the exclusion of warranty; and each file should have at least
-the "copyright" line and a pointer to where the full notice is found.
-
-    <one line to give the program's name and a brief idea of what it does.>
-    Copyright (C) <year>  <name of author>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License along
-    with this program; if not, write to the Free Software Foundation, Inc.,
-    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-
-Also add information on how to contact you by electronic and paper mail.
-
-If the program is interactive, make it output a short notice like this
-when it starts in an interactive mode:
-
-    Gnomovision version 69, Copyright (C) year name of author
-    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
-    This is free software, and you are welcome to redistribute it
-    under certain conditions; type `show c' for details.
-
-The hypothetical commands `show w' and `show c' should show the appropriate
-parts of the General Public License.  Of course, the commands you use may
-be called something other than `show w' and `show c'; they could even be
-mouse-clicks or menu items--whatever suits your program.
-
-You should also get your employer (if you work as a programmer) or your
-school, if any, to sign a "copyright disclaimer" for the program, if
-necessary.  Here is a sample; alter the names:
-
-  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
-  `Gnomovision' (which makes passes at compilers) written by James Hacker.
-
-  <signature of Ty Coon>, 1 April 1989
-  Ty Coon, President of Vice
-
-This General Public License does not permit incorporating your program into
-proprietary programs.  If your program is a subroutine library, you may
-consider it more useful to permit linking proprietary applications with the
-library.  If this is what you want to do, use the GNU Lesser General
-Public License instead of this License.
diff --git a/LICENSE b/LICENSE
new file mode 100644
index 0000000..3211373
--- /dev/null
+++ b/LICENSE
@@ -0,0 +1,21 @@
+Copyright 2019 the fsverity-utils authors
+
+Permission is hereby granted, free of charge, to any person
+obtaining a copy of this software and associated documentation files
+(the "Software"), to deal in the Software without restriction,
+including without limitation the rights to use, copy, modify, merge,
+publish, distribute, sublicense, and/or sell copies of the Software,
+and to permit persons to whom the Software is furnished to do so,
+subject to the following conditions:
+
+The above copyright notice and this permission notice shall be
+included in all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+SOFTWARE.
diff --git a/Makefile b/Makefile
index 7d7247c..e0a3938 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,11 @@
-# SPDX-License-Identifier: GPL-2.0-or-later
+# SPDX-License-Identifier: MIT
 # Copyright 2020 Google LLC
 #
+# Use of this source code is governed by an MIT-style
+# license that can be found in the LICENSE file or at
+# https://opensource.org/licenses/MIT.
+
+
 # Use 'make help' to list available targets.
 #
 # Define V=1 to enable "verbose" mode, showing all executed commands.
diff --git a/NEWS.md b/NEWS.md
index 695a760..e7f2d9d 100644
--- a/NEWS.md
+++ b/NEWS.md
@@ -1,5 +1,9 @@
 # fsverity-utils release notes
 
+## Version 1.2
+
+* Changed license from GPL to MIT.
+
 ## Version 1.1
 
 * Split the file measurement computation and signing functionality
diff --git a/README.md b/README.md
index dfdaeaa..b11f6d5 100644
--- a/README.md
+++ b/README.md
@@ -129,11 +129,8 @@ IMA support for fs-verity is planned.
 
 ## Notices
 
-This project is provided under the terms of the GNU General Public
-License, version 2; or at your option, any later version.  A copy of the
-GPLv2 can be found in the file named [COPYING](COPYING).
-
-Permission to link to OpenSSL (libcrypto) is granted.
+This project is provided under the terms of the MIT license.  A copy
+of this license can be found in the file named [LICENSE](LICENSE).
 
 Send questions and bug reports to linux-fscrypt@vger.kernel.org.
 
diff --git a/common/common_defs.h b/common/common_defs.h
index 4653281..279385a 100644
--- a/common/common_defs.h
+++ b/common/common_defs.h
@@ -1,8 +1,12 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* SPDX-License-Identifier: MIT */
 /*
  * Common definitions for libfsverity and the 'fsverity' program
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 #ifndef COMMON_COMMON_DEFS_H
 #define COMMON_COMMON_DEFS_H
diff --git a/common/libfsverity.h b/common/libfsverity.h
index 2330b4a..450f58e 100644
--- a/common/libfsverity.h
+++ b/common/libfsverity.h
@@ -1,9 +1,13 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* SPDX-License-Identifier: MIT */
 /*
  * libfsverity API
  *
  * Copyright 2018 Google LLC
  * Copyright (C) 2020 Facebook
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #ifndef LIBFSVERITY_H
diff --git a/lib/compute_digest.c b/lib/compute_digest.c
index 85de28e..e0b213b 100644
--- a/lib/compute_digest.c
+++ b/lib/compute_digest.c
@@ -1,9 +1,13 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * Implementation of libfsverity_compute_digest().
  *
  * Copyright 2018 Google LLC
  * Copyright (C) 2020 Facebook
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "lib_private.h"
diff --git a/lib/hash_algs.c b/lib/hash_algs.c
index a25ceb4..510ca3e 100644
--- a/lib/hash_algs.c
+++ b/lib/hash_algs.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * fs-verity hash algorithms
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "lib_private.h"
diff --git a/lib/lib_private.h b/lib/lib_private.h
index dc8448d..54f583e 100644
--- a/lib/lib_private.h
+++ b/lib/lib_private.h
@@ -1,8 +1,12 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* SPDX-License-Identifier: MIT */
 /*
  * Private header for libfsverity
  *
  * Copyright 2020 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 #ifndef LIB_LIB_PRIVATE_H
 #define LIB_LIB_PRIVATE_H
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index af260af..1f73007 100644
--- a/lib/sign_digest.c
+++ b/lib/sign_digest.c
@@ -1,9 +1,13 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * Implementation of libfsverity_sign_digest().
  *
  * Copyright 2018 Google LLC
  * Copyright (C) 2020 Facebook
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "lib_private.h"
diff --git a/lib/utils.c b/lib/utils.c
index 18cb34c..8b5d6cb 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * Utility functions for libfsverity
  *
  * Copyright 2020 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #define _GNU_SOURCE /* for asprintf() and strerror_r() */
diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index f1c0806..d90d208 100644
--- a/programs/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * The 'fsverity enable' command
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "fsverity.h"
diff --git a/programs/cmd_measure.c b/programs/cmd_measure.c
index 4e6cb2b..98382ab 100644
--- a/programs/cmd_measure.c
+++ b/programs/cmd_measure.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * The 'fsverity measure' command
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "fsverity.h"
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 3381ca5..e1bbfd6 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * The 'fsverity sign' command
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "fsverity.h"
diff --git a/programs/fsverity.c b/programs/fsverity.c
index fe00559..95f6964 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * fs-verity userspace tool
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "fsverity.h"
@@ -84,16 +88,8 @@ void usage(const struct fsverity_command *cmd, FILE *fp)
 
 static void show_version(void)
 {
-	printf(
-"fsverity v%d.%d\n"
-"Copyright 2018 Google LLC\n"
-"License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>.\n"
-"This is free software: you are free to change and redistribute it.\n"
-"There is NO WARRANTY, to the extent permitted by law.\n"
-"\n"
-"Report bugs to linux-fscrypt@vger.kernel.org.\n",
-		FSVERITY_UTILS_MAJOR_VERSION,
-		FSVERITY_UTILS_MINOR_VERSION);
+	printf("fsverity v%d.%d\n", FSVERITY_UTILS_MAJOR_VERSION,
+	       FSVERITY_UTILS_MINOR_VERSION);
 }
 
 static void handle_common_options(int argc, char *argv[],
diff --git a/programs/fsverity.h b/programs/fsverity.h
index 9f71ea7..fd9bc4a 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -1,8 +1,12 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* SPDX-License-Identifier: MIT */
 /*
  * Private header for the 'fsverity' program
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 #ifndef PROGRAMS_FSVERITY_H
 #define PROGRAMS_FSVERITY_H
diff --git a/programs/test_compute_digest.c b/programs/test_compute_digest.c
index dc85d01..eee10f7 100644
--- a/programs/test_compute_digest.c
+++ b/programs/test_compute_digest.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * Test libfsverity_compute_digest().
  *
  * Copyright 2020 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "utils.h"
diff --git a/programs/test_hash_algs.c b/programs/test_hash_algs.c
index 16cc408..ede9f05 100644
--- a/programs/test_hash_algs.c
+++ b/programs/test_hash_algs.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * Test the hash algorithm-related libfsverity APIs.
  *
  * Copyright 2020 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "utils.h"
diff --git a/programs/test_sign_digest.c b/programs/test_sign_digest.c
index b0bb328..412c6cb 100644
--- a/programs/test_sign_digest.c
+++ b/programs/test_sign_digest.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * Test libfsverity_sign_digest().
  *
  * Copyright 2020 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "utils.h"
diff --git a/programs/utils.c b/programs/utils.c
index 4792e72..0aca98d 100644
--- a/programs/utils.c
+++ b/programs/utils.c
@@ -1,8 +1,12 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: MIT
 /*
  * Utility functions for the 'fsverity' program
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 
 #include "utils.h"
diff --git a/programs/utils.h b/programs/utils.h
index 07773d3..cd5641c 100644
--- a/programs/utils.h
+++ b/programs/utils.h
@@ -1,8 +1,12 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* SPDX-License-Identifier: MIT */
 /*
  * Utility functions for programs
  *
  * Copyright 2018 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
  */
 #ifndef PROGRAMS_UTILS_H
 #define PROGRAMS_UTILS_H
diff --git a/scripts/do-release.sh b/scripts/do-release.sh
index 68a8ac2..9662919 100755
--- a/scripts/do-release.sh
+++ b/scripts/do-release.sh
@@ -1,6 +1,10 @@
 #!/bin/bash
-# SPDX-License-Identifier: GPL-2.0-or-later
+# SPDX-License-Identifier: MIT
 # Copyright 2020 Google LLC
+#
+# Use of this source code is governed by an MIT-style
+# license that can be found in the LICENSE file or at
+# https://opensource.org/licenses/MIT.
 
 set -e -u -o pipefail
 cd "$(dirname "$0")/.."
diff --git a/scripts/run-sparse.sh b/scripts/run-sparse.sh
index a644bf2..5b6a0ba 100755
--- a/scripts/run-sparse.sh
+++ b/scripts/run-sparse.sh
@@ -1,6 +1,10 @@
 #!/bin/bash
-# SPDX-License-Identifier: GPL-2.0-or-later
+# SPDX-License-Identifier: MIT
 # Copyright 2020 Google LLC
+#
+# Use of this source code is governed by an MIT-style
+# license that can be found in the LICENSE file or at
+# https://opensource.org/licenses/MIT.
 
 set -e -u -o pipefail
 
diff --git a/scripts/run-tests.sh b/scripts/run-tests.sh
index cecd951..092159a 100755
--- a/scripts/run-tests.sh
+++ b/scripts/run-tests.sh
@@ -1,7 +1,12 @@
 #!/bin/bash
-# SPDX-License-Identifier: GPL-2.0-or-later
+# SPDX-License-Identifier: MIT
 # Copyright 2020 Google LLC
 #
+# Use of this source code is governed by an MIT-style
+# license that can be found in the LICENSE file or at
+# https://opensource.org/licenses/MIT.
+#
+#
 # Test script for fsverity-utils.  Runs 'make check' in lots of configurations,
 # runs static analysis, and does a few other tests.
 #
@@ -92,13 +97,19 @@ log "Check that all files have license and copyright info"
 list="$TMPDIR/filelist"
 filter_license_info() {
 	# files to exclude from license and copyright info checks
-	grep -E -v '(\.gitignore|COPYING|NEWS|README|testdata|fsverity_uapi\.h)'
+	grep -E -v '(\.gitignore|LICENSE|NEWS|README|testdata|fsverity_uapi\.h)'
 }
-git grep -L 'SPDX-License-Identifier: GPL-2\.0-or-later' \
+git grep -L 'SPDX-License-Identifier: MIT' \
 	| filter_license_info > "$list" || true
 if [ -s "$list" ]; then
 	fail "The following files are missing an appropriate SPDX license identifier: $(<"$list")"
 fi
+# For now some people still prefer a free-form license statement, not just SPDX.
+git grep -L 'Use of this source code is governed by an MIT-style' \
+	| filter_license_info > "$list" || true
+if [ -s "$list" ]; then
+	fail "The following files are missing an appropriate license statement: $(<"$list")"
+fi
 git grep -L '\<Copyright\>' | filter_license_info > "$list" || true
 if [ -s "$list" ]; then
 	fail "The following files are missing a copyright statement: $(<"$list")"
-- 
2.28.0

