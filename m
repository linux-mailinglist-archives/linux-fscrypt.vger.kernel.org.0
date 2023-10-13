Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C607C7D99
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Oct 2023 08:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjJMGRf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Oct 2023 02:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjJMGRe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Oct 2023 02:17:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13129BC;
        Thu, 12 Oct 2023 23:17:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AF7C433C9;
        Fri, 13 Oct 2023 06:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697177851;
        bh=YBhvTI916LVkHMjXGiOvpvStNhXdCYmcbnbyJPA1tTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqWGY/9Z+Dl4+fwndYsTx6SEnLjjJsi54p/TQli4579ufzzrom6zqT5Nz+shLwJpj
         Y/ky/evntI9dAvXqT37JoSfD1usMCLxyKaOUVL7ayCCfIzfOmAXBFnL5S/S6UjWB3H
         c6UHiIiUgADS4TtiCiGJcWOxNvBNKlQ2nt1uAEH/AYF2Z/QCEVn0P4fAElUrUXFVxY
         WnYBcf/wH+SlHtItIXnQdU9FD2XnfrhjaEEBb3UOnmEX6V4SjBQcMDONj/yJTqYCwx
         wUJ8Z3TsRYSP8b90eJAj1oo2lpETNubeOxJqlIxlLjBKQk8rah0huDrLRfAqPhifsP
         MBmQPnpKc3iNw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 2/4] common/rc: fix _require_xfs_io_command with digits in argument
Date:   Thu, 12 Oct 2023 23:14:01 -0700
Message-ID: <20231013061403.138425-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231013061403.138425-1-ebiggers@kernel.org>
References: <20231013061403.138425-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

'_require_xfs_io_command set_encpolicy -s' does not work as expected
because the following in the output of 'xfs_io -c "help set_encpolicy"':

     -s LOG2_DUSIZE -- log2 of data unit size

... does not match the regex:

    "^ -s ([a-zA-Z_]+ )?--"

... because the 2 in the argument name LOG2_DUSIZE is not matched.  Fix
the regex to support digits in the argument name.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 259a1ffb..b0452360 100644
--- a/common/rc
+++ b/common/rc
@@ -2717,21 +2717,21 @@ _require_xfs_io_command()
 	echo $testio | grep -q "foreign file active" && \
 		_notrun "xfs_io $command $param_checked not supported on $FSTYP"
 	echo $testio | grep -q "Function not implemented" && \
 		_notrun "xfs_io $command $param_checked support is missing (missing syscall?)"
 	echo $testio | grep -q "unknown flag" && \
 		_notrun "xfs_io $command $param_checked support is missing (unknown flag)"
 
 	[ -n "$param" ] || return
 
 	if [ -z "$param_checked" ]; then
-		$XFS_IO_PROG -c "help $command" | grep -E -q "^ $param ([a-zA-Z_]+ )?--" || \
+		$XFS_IO_PROG -c "help $command" | grep -E -q "^ $param ([a-zA-Z0-9_]+ )?--" || \
 			_notrun "xfs_io $command doesn't support $param"
 	else
 		# xfs_io could result in "command %c not supported" if it was
 		# built on kernels not supporting pwritev2() calls
 		echo $testio | grep -q "\(invalid option\|not supported\)" && \
 			_notrun "xfs_io $command doesn't support $param"
 	fi
 
 	# On XFS, ioctl(FSSETXATTR)(called by xfs_io -c "chattr") maskes off unsupported
 	# or invalid flags silently so need to check these flags by extra ioctl(FSGETXATTR)
-- 
2.42.0

