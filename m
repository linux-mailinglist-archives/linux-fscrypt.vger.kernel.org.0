Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E1158657
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBKAAm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:00:42 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44225 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBKAAm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:00:42 -0500
Received: by mail-pl1-f194.google.com with SMTP id d9so3467331plo.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6aaH26v2TlMwCnznay0EXwxavt+XQg2sYxqzEBjwvqc=;
        b=PlLIJH8neY8hgmZv1XLtVhIUrY+6vcAks42elQHDtSh7Fo0b0tQRQjAgQpGwelUTYA
         0gr5qSaKnC0QT0+EU+hd7tJYu6vEseHAUfK4bS45C4M6l6lp6Rxyw/5kryHX8fHddQQv
         W0FeRUjUksTD8mw5rp4n36RKZzJ+n0gELbMepxbSsr5Z2k910eWMZ9GBbaBaz/ZDxYJh
         T7rnArkcEuo2EHRSFxSfLJI3y8egcN5PG0PdjRkZoSkSSlPlMqmVTQzcEmh4ZCGSmwOC
         CNIi+XDR0U22izLJhOsjnGCRfS+e58lcQaZDnIlOx/6mZdPqUi+QFZSX646bH1zRd93M
         AJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6aaH26v2TlMwCnznay0EXwxavt+XQg2sYxqzEBjwvqc=;
        b=NzK7mDJFmNB6/J0vKHqLwpc52yy9+10ODMfrJINnD7i0h+Pm47eXabivaAmYhEOP0D
         PvF2rQ8uKmzNvtnVRe20YYtEBfxKHyKNo1Hs2oUikeVops1pjsQxX07FlkLXxCIkLCEt
         1VrdiFilmYlEDLK3XZYuUjxpth2qHJk8mlIpc/xpXMnKAUAvv8Gz+QEFbMFAqMneWLpt
         PigMW4eMGz7CP53ml35MGe7fImZEIrdM7MoPQTjpvVSsIwKNtIIS3COrsJYbP/s0pHIW
         JArvRrT12X7HcMzidZ81FzDKRGsan4MHpLhykrznJY4aaTj2MfFEf0L/g3VnPQP+rtqm
         RwRQ==
X-Gm-Message-State: APjAAAVG7SmR4vMhFBSGCee20HhTSnPZ1/nMJoLZCNfGW/9ZopM4EMMc
        8XefzWYq793JEjr9b4ugEy6TBMRC9gU=
X-Google-Smtp-Source: APXvYqy4ldA8SvS0vVmn1uA3RiDfzTrXkBFTkmT0JEB1yG7Uba7hoKiprcObh5Dns4F7qNCCv9bqTw==
X-Received: by 2002:a17:902:7006:: with SMTP id y6mr473470plk.84.1581379241358;
        Mon, 10 Feb 2020 16:00:41 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id f43sm508133pje.23.2020.02.10.16.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:00:40 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 0/7] Split fsverity-utils into a shared library
Date:   Mon, 10 Feb 2020 19:00:30 -0500
Message-Id: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Hi,

I am looking at what it will take to add support for fsverity
signatures to rpm, similar to how rpm supports IMA signatures.

In order to do so, it makes sense to split the fsverity util into a
shared library and the command line tool, so the core functions can be
used from other applciations. Alternatively I will have to copy over a
good chunk of the code into rpm, which makes it nasty to support long
term.

This is a first stab at doing that, and I'd like to get some feedback
on the approach.

I basically split it into four functions:

fsverity_cmd_gen_digest(): Build the digest, but do not sign it
fsverity_cmd_sign():       Sign the digest structure
fsverity_cmd_measure():    Measure a file, basically 'fsverity measure'
fsverity_cmd_enable():     Enable verity on a file, basically 'fsverity enable'

If we can agree on the approach, then I am happy to deal with the full
libtoolification etc.

Jes


Jes Sorensen (7):
  Build basic shared library
  Restructure fsverity_cmd_sign for shared libraries
  Make fsverity_cmd_measure() a library function
  Make fsverity_cmd_enable a library call()
  Rename commands.h to fsverity.h
  Move cmdline helper functions to fsverity.c
  cmd_sign: fsverity_cmd_sign() into two functions

 Makefile      |  18 ++-
 cmd_enable.c  | 133 +------------------
 cmd_measure.c |  51 ++------
 cmd_sign.c    | 168 ++++++------------------
 commands.h    |  24 ----
 fsverity.c    | 345 +++++++++++++++++++++++++++++++++++++++++++++++---
 fsverity.h    |  38 ++++++
 util.c        |  13 ++
 8 files changed, 446 insertions(+), 344 deletions(-)
 delete mode 100644 commands.h
 create mode 100644 fsverity.h

-- 
2.24.1

