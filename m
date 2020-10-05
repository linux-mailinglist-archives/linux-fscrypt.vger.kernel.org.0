Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2D7283101
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Oct 2020 09:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgJEHlj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Oct 2020 03:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgJEHlj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Oct 2020 03:41:39 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266FAC0613CE
        for <linux-fscrypt@vger.kernel.org>; Mon,  5 Oct 2020 00:41:39 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 139so6001274qkl.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 05 Oct 2020 00:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=cGuAlaeZa+fmThCbpZs6t/+dBJ0JbAyRdYvCYkXQIzo=;
        b=EP1SkITH6nDQZDWUU1Uc+q768nllvBnXoM0IIfWmlFqo3T0ux+TM7Mf2z1UAwoqFxj
         PaeTydbB3wNHeOtz9oXhetYgUlc766ol57BbEf33wkb5Cf5V+aUl7gGlOmKMAFAH2OeO
         2TIOPF2+WcgQmQiyror2IePJNc212sveSA+nwOE7VhGBBNC0CANv6GVUeL/lHXixhIsJ
         i53323nttLX+w3GBsyexL60Ii9jpzCCC6uPxxLViqO7MKFSvipW7cR9kgux5yVQms1dQ
         CWx23OCWHXyEK5zUvTdFHoTW2v65PPstXw+YkS25qKvhvWZoWVviSExFXkJnIjOQUMmQ
         9TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=cGuAlaeZa+fmThCbpZs6t/+dBJ0JbAyRdYvCYkXQIzo=;
        b=ixYOKsPKSgaHhN3eNXxmniNyHSJVijc2XmFbBNO4yLryKl7lejrI65NoTBIMzxRV3n
         ITBH6kXdZ8aqB68AQebg/C++j8TiTGmlYa/5SuAb/DtmKfmCiJ8AoWEGI1SHOiKOrdD5
         9AnFt70R6jCTvoeJANiEITyR3MGYUqAPIgi2KtKoP9QxxXqsDtHnQmPcEte4QMRnQE81
         vrxr7aAMAqd70Oq5A4/HQNl6EhetgUOoSay2o+aQ/IuMSpc0KPaPq8aH64NUK9LkTaU1
         ErpaYlJqlbcqFVaEbu/uQ0odTcP6PiMFI1RGuW0TQ/Z1Z8UjT+RwdPqB8+jSu7MWk4fe
         UWtg==
X-Gm-Message-State: AOAM530A8au2Xy0kgmplQ6/4w87cWKt4hihzKSQpJjZyWT8aEFBZLr57
        /T7sTtpry4Kke6Spvj3s03muZfwdLfo=
X-Google-Smtp-Source: ABdhPJy6ycq5SeVkN+WkkgDF0w8+sYBA0b89QHrmuAKlNY/nUoXchIEgX2O5U5eKs0kimydvOqIJQHYl4iA=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a0c:8c4c:: with SMTP id o12mr5153494qvb.46.1601883698196;
 Mon, 05 Oct 2020 00:41:38 -0700 (PDT)
Date:   Mon,  5 Oct 2020 07:41:32 +0000
Message-Id: <20201005074133.1958633-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 0/1] userspace support for F2FS metadata encryption
From:   Satya Tangirala <satyat@google.com>
To:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The kernel patches for F2FS metadata encryption are at:

https://lore.kernel.org/linux-fscrypt/20201005073606.1949772-4-satyat@google.com/

This patch implements the userspace changes required for metadata
encryption support as implemented in the kernel changes above. All blocks
in the filesystem are encrypted with the user provided metadata encryption
key except for the superblock (and its redundant copy). The DUN for a block
is its offset from the start of the filesystem.

This patch introduces two new options for the userspace tools: '-A' to
specify the encryption algorithm, and '-M' to specify the encryption key.
mkfs.f2fs will store the encryption algorithm used for metadata encryption
in the superblock itself, so '-A' is only applicable to mkfs.f2fs. The rest
of the tools only take the '-M' option, and will obtain the encryption
algorithm from the superblock of the FS.

Limitations: 
Metadata encryption with sparse storage has not been implemented yet in
this patch.

This patch requires the metadata encryption key to be readable from
userspace, and does not ensure that it is zeroed before the program exits
for any reason.

Satya Tangirala (1):
  f2fs-tools: Introduce metadata encryption support

 fsck/main.c                   |  47 ++++++-
 fsck/mount.c                  |  33 ++++-
 include/f2fs_fs.h             |  10 +-
 include/f2fs_metadata_crypt.h |  21 ++++
 lib/Makefile.am               |   4 +-
 lib/f2fs_metadata_crypt.c     | 226 ++++++++++++++++++++++++++++++++++
 lib/libf2fs_io.c              |  87 +++++++++++--
 mkfs/f2fs_format.c            |   5 +-
 mkfs/f2fs_format_main.c       |  33 ++++-
 9 files changed, 446 insertions(+), 20 deletions(-)
 create mode 100644 include/f2fs_metadata_crypt.h
 create mode 100644 lib/f2fs_metadata_crypt.c

-- 
2.28.0.806.g8561365e88-goog

