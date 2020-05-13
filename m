Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F581D0412
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2020 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbgEMA4B (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 May 2020 20:56:01 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55970 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732082AbgEMAz7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 May 2020 20:55:59 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04D0tcEU000849
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 20:55:39 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C4B6E4202E4; Tue, 12 May 2020 20:55:38 -0400 (EDT)
Date:   Tue, 12 May 2020 20:55:38 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 2/4] fscrypt: add fscrypt_add_test_dummy_key()
Message-ID: <20200513005538.GF1596452@mit.edu>
References: <20200512233251.118314-1-ebiggers@kernel.org>
 <20200512233251.118314-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512233251.118314-3-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 12, 2020 at 04:32:49PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently, the test_dummy_encryption mount option (which is used for
> encryption I/O testing with xfstests) uses v1 encryption policies, and
> it relies on userspace inserting a test key into the session keyring.
> 
> We need test_dummy_encryption to support v2 encryption policies too.
> Requiring userspace to add the test key doesn't work well with v2
> policies, since v2 policies only support the filesystem keyring (not the
> session keyring), and keys in the filesystem keyring are lost when the
> filesystem is unmounted.  Hooking all test code that unmounts and
> re-mounts the filesystem would be difficult.
> 
> Instead, let's make the filesystem automatically add the test key to its
> keyring when test_dummy_encryption is enabled.
> 
> That puts the responsibility for choosing the test key on the kernel.
> We could just hard-code a key.  But out of paranoia, let's first try
> using a per-boot random key, to prevent this code from being misused.
> A per-boot key will work as long as no one expects dummy-encrypted files
> to remain accessible after a reboot.  (gce-xfstests doesn't.)
> 
> Therefore, this patch adds a function fscrypt_add_test_dummy_key() which
> implements the above.  The next patch will use it.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

