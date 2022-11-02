Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D6F615BE3
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 06:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKBFgu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 01:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKBFgt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 01:36:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FFA5FA9;
        Tue,  1 Nov 2022 22:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D366129E;
        Wed,  2 Nov 2022 05:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4529C433C1;
        Wed,  2 Nov 2022 05:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667367407;
        bh=0lANP03Aj6kK9N5O6pFMuimVb0FxMVsrJmTlx5+QQJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=nicGbXurK4cUfxHrcLnpjnCXbss8czzlNHuJWtDOpU+TUkcaPWiK5ARmOLbR4tREH
         M1/vXW6D7X8hKwB8yxotBaVnKoxvHqVVyEupefTVvU6D6Q8ZfJJeSXtMTQP44X/gcp
         H7o8AC3Kxm170z7dabInn0mghPvJhefkfhK8QxNPp3qDsau6EQj+mtaJUTl0QmKiUG
         EjvEDhzCiwQPu4lJjJaBBzk35TxiRKcYCiCBZl1gzu6eb35eDYD0FSnP/tnqe6DRTg
         JMpX04vFWvo/dlMeRQni8yyd0I4cNlWYHmgyFnu/kJu3IDr9SHLByfjhARYGZHewiC
         2yDWGZECwG1YA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [e2fsprogs PATCH] e2fsck: don't allow journal inode to have encrypt flag
Date:   Tue,  1 Nov 2022 22:35:54 -0700
Message-Id: <20221102053554.190282-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since the kernel is being fixed to consider journal inodes with the
'encrypt' flag set to be invalid, also update e2fsck accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 e2fsck/journal.c                   |   3 ++-
 tests/f_badjour_encrypted/expect.1 |  30 +++++++++++++++++++++++++++++
 tests/f_badjour_encrypted/expect.2 |   7 +++++++
 tests/f_badjour_encrypted/image.gz | Bin 0 -> 2637 bytes
 tests/f_badjour_encrypted/name     |   1 +
 5 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_badjour_encrypted/expect.1
 create mode 100644 tests/f_badjour_encrypted/expect.2
 create mode 100644 tests/f_badjour_encrypted/image.gz
 create mode 100644 tests/f_badjour_encrypted/name

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index d802c5e9..343e48ba 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -1039,7 +1039,8 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			tried_backup_jnl++;
 		}
 		if (!j_inode->i_ext2.i_links_count ||
-		    !LINUX_S_ISREG(j_inode->i_ext2.i_mode)) {
+		    !LINUX_S_ISREG(j_inode->i_ext2.i_mode) ||
+		    (j_inode->i_ext2.i_flags & EXT4_ENCRYPT_FL)) {
 			retval = EXT2_ET_NO_JOURNAL;
 			goto try_backup_journal;
 		}
diff --git a/tests/f_badjour_encrypted/expect.1 b/tests/f_badjour_encrypted/expect.1
new file mode 100644
index 00000000..e88e3770
--- /dev/null
+++ b/tests/f_badjour_encrypted/expect.1
@@ -0,0 +1,30 @@
+Superblock has an invalid journal (inode 8).
+Clear? yes
+
+*** journal has been deleted ***
+
+Pass 1: Checking inodes, blocks, and sizes
+Journal inode is not in use, but contains data.  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(32--33) -(35--49) -(115--1121)
+Fix? yes
+
+Free blocks count wrong for group #0 (926, counted=1950).
+Fix? yes
+
+Free blocks count wrong (926, counted=1950).
+Fix? yes
+
+Recreate journal? yes
+
+Creating journal (1024 blocks):  Done.
+
+*** journal has been regenerated ***
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/256 files (0.0% non-contiguous), 1122/2048 blocks
+Exit status is 1
diff --git a/tests/f_badjour_encrypted/expect.2 b/tests/f_badjour_encrypted/expect.2
new file mode 100644
index 00000000..a3744874
--- /dev/null
+++ b/tests/f_badjour_encrypted/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/256 files (9.1% non-contiguous), 1122/2048 blocks
+Exit status is 0
diff --git a/tests/f_badjour_encrypted/image.gz b/tests/f_badjour_encrypted/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..660496ea5bba9b5589e6ce522feb998a56ab946a
GIT binary patch
literal 2637
zcmb2|=3oE;CgwMHnR%A}ly$iH+hCjen-$w~Z}VkIC+6NxyCc!NYR5sNh}+xBbE4nR
zN&o!s6aW5(lcp<{UH`qxzUS4ptP5pfA==wwf8L3{|MOkc?r&esd8Bgo#^iqA5gFQC
z<@R-dVr@lCdHkR5{rAnDhwlG>jraZU^QHBbXJlmsKi|6fW!ukpZ~6bfSpUB2;pTmx
zj{M*I=+61|wWkw4%t_n+w)pIx)GIr3+pcz<UH*C1)vHaf+5&5L-JN;=TiBLGj=QD!
zvwYR3oA+2BEcm`&zU2O)tkADJdjH<PwxLjZ&!1oZHNUt0v)ga`;{kvAnl~H3enld#
z$+@%1mc~a}A54fin`clHvi0Skf*&i~udaD@=i-@%?sorPp11i^EC2t^@q3p&nP$X3
zzi$!s_i3c{*ZQX!$^Q>{-utf_{{O+ORnhK@!q@)4KVSKq`3wIq_AmS|<S*DSsCW3^
z@Q?8?^DlP4J^%iH{<8evDyi)kD?Tqg`0VhxvhA|(9o0n`65ek4mi5+?8xj$4$636y
z`F^c@U-jvQi=WK?|9-~qcRR0El+UlfvVnKm_Je1l*?MoM1?axIu;=xksEaRLt^f1+
zcI>}%!KM17_pFRy`>QV2pCx6B<9`)>o$;~a`cLx=*Y;<@Z|{cwUm;riQQi9d{>A@(
z&c6T7uKx1sm(kDuuPD6Dvs!ev|MSq*t68t|F8)>W`}uD3t6l#pUM)HIKYZ_&&TqRj
zWsCn;=6#)UcWr%}?)}rh(#y8)a4!C~Kik#*_w$dx|Fgp#PX@#7>W*1KzH66-US2JE
z^-NZn>F!y<XV*Rp{k)o$kqqNTwTy<qXb9jBf%d~z-yS%C)HqDo|5YJ89>4NY+0hUf
k4S}H$0uFBvZUnjWfI|K2%r`6YXzOOCSzdj93=9ek0BUk;ZvX%Q

literal 0
HcmV?d00001

diff --git a/tests/f_badjour_encrypted/name b/tests/f_badjour_encrypted/name
new file mode 100644
index 00000000..e8f4c04f
--- /dev/null
+++ b/tests/f_badjour_encrypted/name
@@ -0,0 +1 @@
+journal inode has encrypt flag

base-commit: aad34909b6648579f42dade5af5b46821aa4d845
-- 
2.38.1

