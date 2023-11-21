Return-Path: <linux-fscrypt+bounces-8-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2FE7F394E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 23:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B789282A8D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 22:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8B55576C;
	Tue, 21 Nov 2023 22:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pm0hdeER"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E854207D;
	Tue, 21 Nov 2023 22:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372DCC433CA;
	Tue, 21 Nov 2023 22:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700606376;
	bh=KtsSq5LYvPatFAAXEjl+Y4OaaAiq0o6mzQHlHZHSUC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pm0hdeERQdM86iFIoenPcFcCHMgeHmJ5ufw1PyLPxu3eurY+ylVFB3V7VF6CUIe3o
	 dgBuXop3SNQ7eSXkgyl33LvcRTmsosZqpfm1Oq071kcquPsWmQ2VSLbpdXT9HCATOt
	 IFqRGJlQQXjS0XvHw50LI+HZ70xqaZ7O4zcv/EutWn2keDZMoIh7H2iU37x8Bvb9PW
	 7mTg2WJEV0zRMbi5JcNw4ThThFDf0lMsYfOFHb/11z6QlZf+QSQQ1eikoIprv/YFbQ
	 iJn8DNQXc8vygVj+20jAfHjkR1i1ybaM8X1ZA5H2ec/A+opn7I/hb0Qe30/5iKYmuD
	 13RLPhNS+yflg==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 2/4] common/rc: fix _require_xfs_io_command with digits in argument
Date: Tue, 21 Nov 2023 14:39:07 -0800
Message-ID: <20231121223909.4617-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231121223909.4617-1-ebiggers@kernel.org>
References: <20231121223909.4617-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index cc92fe06..dab672d8 100644
--- a/common/rc
+++ b/common/rc
@@ -2719,21 +2719,21 @@ _require_xfs_io_command()
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
2.42.1


