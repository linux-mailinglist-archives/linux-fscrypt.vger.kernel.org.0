Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EAE2B2673
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgKMVUs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgKMVUs (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:20:48 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9498F2224D;
        Fri, 13 Nov 2020 21:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605302447;
        bh=lHG67jCwlXDOXYcH0JFV147ai3EJuiVcohNYuZtoKao=;
        h=From:To:Cc:Subject:Date:From;
        b=Zofi9SqUtf/16Mc2gwiDprGXOQdGfJyGLABQRkby28VuHxeThjyzpn07RsxKY/Ucq
         IL+KarKlG9I6CkOuWEBcl3TrgYhNO5U25I8NK7vhRUMuxup/C/cbjH0mli2KY6ubFe
         x1wDWcM5+pChrPuMOGxVBQVn44nhp2oHnlmJqEZ8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Subject: [PATCH 0/4] fs-verity cleanups
Date:   Fri, 13 Nov 2020 13:19:14 -0800
Message-Id: <20201113211918.71883-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset renames some names that have been causing confusion:

- fsverity_signed_digest is renamed to fsverity_formatted_digest

- "fs-verity file measurement" is renamed to "fs-verity file digest"

In addition, this patchset moves fsverity_descriptor and
fsverity_formatted_digest to the UAPI header because userspace programs
may need them in order to sign files.

Eric Biggers (4):
  fs-verity: remove filenames from file comments
  fs-verity: rename fsverity_signed_digest to fsverity_formatted_digest
  fs-verity: rename "file measurement" to "file digest"
  fs-verity: move structs needed for file signing to UAPI header

 Documentation/filesystems/fsverity.rst | 68 ++++++++++++--------------
 fs/verity/enable.c                     |  8 +--
 fs/verity/fsverity_private.h           | 36 ++------------
 fs/verity/hash_algs.c                  |  2 +-
 fs/verity/init.c                       |  2 +-
 fs/verity/measure.c                    | 12 ++---
 fs/verity/open.c                       | 24 ++++-----
 fs/verity/signature.c                  | 14 +++---
 fs/verity/verify.c                     |  2 +-
 include/uapi/linux/fsverity.h          | 49 +++++++++++++++++++
 10 files changed, 116 insertions(+), 101 deletions(-)

-- 
2.29.2

