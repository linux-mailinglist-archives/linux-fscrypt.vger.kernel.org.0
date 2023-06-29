Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75992743042
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 00:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjF2WRl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 18:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjF2WRh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 18:17:37 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467A630F1;
        Thu, 29 Jun 2023 15:17:37 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 85C7080778;
        Thu, 29 Jun 2023 18:17:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688077057; bh=i0KcUcAyrGMIC1rkAvJHWWPwsKlFh9C7E3KShPZecpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmKY/PEVkr8Lggi8AWIn5/LeqkL7CmYkv/qtytB645XYxd279Ow1Pr0ejCMk/Nr2x
         CMHkVuqCIgdlC3C3lEwYfxpJG9lOnfPJkT8WtT/S83m9qDwbQejl97T/US/UNhoXZu
         oZApUSt5cvQIujFC1ALCmOqDaie6pF79TWvAfDFFACuk5VgOxD4M1Xi7lNYk3k3QQH
         XReu0Hw7hinuv1nN3fSVOXs6ivwUFohzdvYAoGysgGpXwsaBhtyICM95NEsAHtuW7k
         GiybeQBSGMY9QheNzgGlNCMbNPIvUYFB4ocOPB4+imA7s4gGbEHS8UQANqWBRTY41z
         zgyaLsVPypm2Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 3/8] common/encrypt: add btrfs to get_ciphertext_filename
Date:   Thu, 29 Jun 2023 18:17:18 -0400
Message-Id: <023efcfc72f3ebe66ed66513529c207334ab9eea.1688076612.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688076612.git.sweettea-kernel@dorminy.me>
References: <cover.1688076612.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add the relevant call to get an encrypted filename from btrfs.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/encrypt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index fc1c8cc7..2c1925da 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -618,6 +618,19 @@ _get_ciphertext_filename()
 	local dir_inode=$3
 
 	case $FSTYP in
+	btrfs)
+		# Extract the filename from the inode_ref object, similar to:
+		# item 24 key (259 INODE_REF 257) itemoff 14826 itemsize 26
+		# 	index 3 namelen 16 name: J\xf7\x15tD\x8eL\xae/\x98\x9f\x09\xc1\xb6\x09>
+		#
+		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
+			grep -A 1 "key ($inode INODE_REF " | tail -n 1 | \
+			perl -ne '
+				s/.*?name: //;
+				chomp;
+				s/\\x([[:xdigit:]]{2})/chr hex $1/eg;
+				print;'
+		;;
 	ext4)
 		# Extract the filename from the debugfs output line like:
 		#
@@ -715,6 +728,9 @@ _require_get_ciphertext_filename_support()
 			_notrun "dump.f2fs (f2fs-tools) is too old; doesn't support showing unambiguous on-disk filenames"
 		fi
 		;;
+	btrfs)
+		_require_command "$BTRFS_UTIL_PROG" btrfs
+		;;
 	*)
 		_notrun "_get_ciphertext_filename() isn't implemented on $FSTYP"
 		;;
-- 
2.40.1

