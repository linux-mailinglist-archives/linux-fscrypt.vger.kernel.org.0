Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDA539AB32
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Jun 2021 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhFCUBw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Jun 2021 16:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhFCUBu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Jun 2021 16:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE294613D7;
        Thu,  3 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750405;
        bh=5Qil6u1Cz5wxKNeACvqfRrNuafRulDzaFlCSN37+IXw=;
        h=From:To:Cc:Subject:Date:From;
        b=WfCNQ/GHmJWyfA94lILHlrFfsjZsfZwDNhDAlZ/K48vHwQPOpvpdzr7sBBdTTlmpr
         RZ1jfJgNC8DxEQMrrTVXJ9nsJE9WnAMqzzNzVAMZ7pQe+Q74OlOvr7b14mjsUMR4x2
         K6FJYn3uiLkr0TfbmbGlsQckb/Ui8TjH72gLtCO/y4vWxYW8J/zV03p7zgRq5oSg1f
         mVvE0t3uUz/l8D8T82w2aPjjpNI8ZeXwjGFb+CwM4dq8qMAx9AX4hTAVGPFETeYjzI
         N32bM9Q66rQiiwGLv+zaE0Y1o9QvqQV9GDndSYggVJCZxJUxrcy0VMNiRYDBE0swtf
         sk9nK5bHP10MA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils PATCH 0/4] Add option to write Merkle tree to a file
Date:   Thu,  3 Jun 2021 12:58:08 -0700
Message-Id: <20210603195812.50838-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Make 'fsverity digest' and 'fsverity sign' support writing the Merkle
tree and fs-verity descriptor to files, using new options
'--out-merkle-tree=FILE' and '--out-descriptor=FILE'.

Normally these new options aren't useful, but they can be needed in
cases where the fs-verity metadata needs to be consumed by something
other than one of the native Linux kernel implementations of fs-verity.

This is different from 'fsverity dump_metadata' in that
'fsverity dump_metadata' only works on a file with fs-verity enabled,
whereas these new options are for the userspace file digest computation.

Supporting this required adding some optional callbacks to
libfsverity_compute_digest().

Eric Biggers (4):
  lib/compute_digest: add callbacks for getting the verity metadata
  programs/test_compute_digest: test the metadata callbacks
  programs/utils: add full_pwrite() and preallocate_file()
  programs/fsverity: add --out-merkle-tree and --out-descriptor options

 include/libfsverity.h          |  46 +++++++++++-
 lib/compute_digest.c           | 130 +++++++++++++++++++++++++++-----
 programs/cmd_digest.c          |   7 +-
 programs/cmd_sign.c            |  17 +++--
 programs/fsverity.c            |  88 +++++++++++++++++++++-
 programs/fsverity.h            |   4 +-
 programs/test_compute_digest.c | 133 +++++++++++++++++++++++++++++++++
 programs/utils.c               |  59 +++++++++++++++
 programs/utils.h               |   3 +
 9 files changed, 458 insertions(+), 29 deletions(-)


base-commit: cf8fa5e5a7ac5b3b2dbfcc87e5dbd5f984c2d83a
-- 
2.31.1

