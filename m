Return-Path: <linux-fscrypt+bounces-1605-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8CfGA5P/D2qLSQYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1605-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 09:02:43 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A645AFC98
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 09:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C9CF3021E59
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 07:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6573A384CED;
	Fri, 22 May 2026 07:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HLzHPZrA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863AB368D4F
	for <linux-fscrypt@vger.kernel.org>; Fri, 22 May 2026 07:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779433261; cv=pass; b=ogKv6N+DR1vqiyVPy5UuqL42u8AAjcJLN9cYAnYygYMXVNqUeI3qbRcMfa2c2z9btPWKFtsA4I/VzlKqK0aTNjqU/u71K0fv4ms6jeJEp2M1bkvbNNeNLkfrbwESUQlUEHIsrM1jwfzYtw1w+aJchB4XmhzLHzlRUqadS3r9W4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779433261; c=relaxed/simple;
	bh=RPLULZwyGFBcnLzO3/6uBXaB8JE/6zjrHV/JLXWUDl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NehmH6QCAgXtUU0Se0d/r1A9IQDZ1/n52kvlsciQwYzZStl9XTUVQMwwkTZZ4pEYSi+PcSxk4rJDhrEgAJToYFVS7uAiCweJLtdCzT4+yUsbOJPLrOmNlDObRs2YAg0RAOirMSXzWWMCPFX+Lq3OYIQdYFMiJaSvaCco3+dtauA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HLzHPZrA; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so95966685e9.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 22 May 2026 00:00:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779433258; cv=none;
        d=google.com; s=arc-20240605;
        b=bZUv7OMOzUm2v4XbbVK3GsCIESgOm51Ye/yvQ+FNn8/Cj/qWBzr2EGW0SGOcnIpxX+
         TKOIYYbWjveD0/JXqMkEO6JCr6RM7080FN5U4R5vCafnLU7heHoE3kYfeAbLMcjM2zKj
         OrNFJ2/pP4aMVW6Gyl6YWSI6HU1uUiV8Q8uhk7S5eyoBL4R6uPYr3XXFYnFNIFojDn1d
         N2FNtxBtDTLuO+0AkAUHLSK8xCvI7tkZAibQwZTzKtQ05T7BBze00qSCg2uk5PrcGxgN
         buIcnHhdg3c279gzFgEUfxKaxwTp91SOunWuwEHdawlPUuYPFFE+IM3zqOqRYUiHE6OU
         4qiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DgrJhf9pCLWRyhDeCL2ag+63OL5JMEGKJLqO1vcQ/ro=;
        fh=2M/wtRfGu9ohEZpTBo/ieRM7BvwH+Fsry9PxdtWlQh4=;
        b=WZ9DtJ6N45SBeb3Rp1lfJbMGOrZQBd+1KHdbF71aSegpjfACQUwGNUtGVjbQkyn3k+
         qgKXlMw8v6EZvIqNNC+YS7OcKfMiYHdF9PnoahNjKfy+OBvabmuBg35JTG5w6zXkYlsl
         9hEa5bRE5MqR9jilAEgpPb0cdzOORIvidQh5hITe3UVGr1nmR9xN1Oqt4iDJhmvgP9DR
         UH67oohAjTng8zE3zNDPhK4CXp++a/tOPOsMmPkcXiQsveqhxqH9dpq19X57PrTOLCZm
         wOlfi3Khk8kXuMc0YS7cmDTgk5SgZYy2CU6AEiDraoNYEZvVaFY8d2Vg6zC5JQBxAjUs
         Cbqg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779433258; x=1780038058; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DgrJhf9pCLWRyhDeCL2ag+63OL5JMEGKJLqO1vcQ/ro=;
        b=HLzHPZrA6n4uD7WqH3WLxWPD+3X9IiQxUW7HukJBPo7Mvwsojo4BP6KnY7uSUKLIWi
         opGFMqwn4+HijbCbKmiy4klL/LZdhnJVTVcybWHMz+fREl7R7fdrp7+wZ72QwznzPmx6
         jMZQMvZADyTeH4OzWGXbDbb/d4BWzVjOsHJApUlZtKXEETqJ4WWFNjczpfjgKm/GyRUv
         HN0xRFVD7oDKuUdiPVdHJjJ8pc7XT0lIGCs1bEThAlru00LEmt5w7X7A0jH9DZNVc0ga
         yax1LGmHjLJyGD24nv3bH/tJqhIfAC6dA41VqwTSPTPFP3sW0NN5McELKrCbW2VoYPe8
         v5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779433258; x=1780038058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgrJhf9pCLWRyhDeCL2ag+63OL5JMEGKJLqO1vcQ/ro=;
        b=YERJcljubuAjEpZWoFJIkkw+34bgMcdeJxbSemKYAvti1f9luiie8Hp3tb6NcK9sWd
         wuwhE8P1TmHbPubmRlYbwFMmbaNanws3p8TcvQWt1PihKj8W4hBA+Nr6ZNcu4PsTMwc6
         UinsncwfNDcxsf253yVL33z+SeaNNbg8RqwKv2mCkjlyxAoIM3h0Vtrg7M47APxPix7T
         GDJYeIbvNxF4MONeGQaRXW2T3aa0QKjdcV5Sqf9250zQW6yaV95a7YIaPST5yDJbMcxt
         vlJ9Ne0/KEyUDaLXRlnA8ZmwKklr+gftlHWMzVTrX5q2fmsnRbFcN29Tp5DIvefgPjeO
         J/ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ+dKfo8aTCPQGLzI83nK1X0ypAcMR6FMz7YQelR7i8TxsXPnJSGnHMP5cufkB5edc6ZzkiZPVUmzYdMcqxq@vger.kernel.org
X-Gm-Message-State: AOJu0YyFLn3qCd2Nvu/ME0sq3fDLVMtF+K2Hob1uAAvuB5BPatlmza64
	UHFZYYwRpjY1casjdOqoIzvREAk+mgP3UjcAKo2Eu9tFUrkwHm5rNiA8ZoIuk/+k6yPjIL1DNfW
	tyATPFPFTh/Pi2kPXRlAEMS6/IfDl52J/jDNs8mibH5+Kvwen9clCkdE=
X-Gm-Gg: Acq92OGqr1Mvh2dAw3rdiitRKnhlHqe2YTf7Lc7tNOcTlz0WWSVRHZmLmp4uwldaZ6P
	yQjpNk4ljgoKgMKczZ6L4lEXkxuKlMDFv6uTO4O0qdFRFk0AexiowuQ400uilHyc9Eg9eISIYOm
	I8ub0W3jaCTday5v1hRSTUCCuCxWfohNBdbFBKXht/SF4Eg3uINNUP9CA6pmOQXTeFEjcttB4yw
	/kJw91tdhgHUAB62u647wJvHpKZMe18/LazdvJTeJmdDuZag+uYx9KUx3k1tR+pfSmyfoo6cS5L
	xzVu//XWvM4Mw886CBi/v/Ik7aGhXzpKJoG7WBIa1+0nGlDffL63482nzdRQTOM8RGzX5akuq9A
	3ujdTP4O2PuDjbfM=
X-Received: by 2002:a05:600c:1c0b:b0:488:b187:3c with SMTP id
 5b1f17b1804b1-490426aa7acmr30260965e9.14.1779433257800; Fri, 22 May 2026
 00:00:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com>
In-Reply-To: <20260513085340.3673127-1-neelx@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 22 May 2026 09:00:46 +0200
X-Gm-Features: AVHnY4KaCg2TnL5N7-_bJO4bF9ZVXcF6atGf4TwugcWam8oNLxjSD5HXNcr7eME
Message-ID: <CAPjX3FdHJpZUVk2dfA+Ov5K6vOSsOJMUaxCU4G8y1qg6baMXYw@mail.gmail.com>
Subject: Re: [PATCH v7 00/43] btrfs: add fscrypt support
To: Eric Biggers <ebiggers@kernel.org>, David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1605-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:email,suse.com:dkim]
X-Rspamd-Queue-Id: A8A645AFC98
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 13 May 2026 at 10:54, Daniel Vacek <neelx@suse.com> wrote:
>
> Hello,
>
> These are the remaining parts from former series [1] from Omar, Sweet Tea
> and Josef.  Some bits of it were split into the separate set [2] before.
>
> Notably, at this stage encryption is not supported with RAID5/6 setup
> and send is also disabled for now.
>
> For straight git access you can find this series as the `fscrypt-v7` tag
> e85358ef9fba here:
>
> [0] https://github.com/dvacek/linux-btrfs/tree/fscrypt-v7
>
> Changes since v6 [3]
>  * Rebased onto linux v7.1-rc3.
>  * Adapted to the v7.0 fscrypt API changes, mostly following commit
>    bb8e2019ad613 ("blk-crypto: handle the fallback above the block layer")
>  * Addressed all the review feedback, thanks to Eric Biggers, Chris Mason
>    (and his LLM review prompts) and Neal Gompa.
>  * Adapted to the v7.1 fscrypt API cleanups, using byte offsets as function
>    arguments instead of logical block numbers for newly introduced functions.
>    This should match https://lore.kernel.org/linux-fscrypt/20260218061531.3318130-1-hch@lst.de/
>    As a result btrfs_set_bio_crypt_ctx_from_extent() and btrfs_mergeable_encrypted_bio()
>    helpers were no longer needed and they got removed.

Hi Eric,

This is just a gentle ping.
I was wondering if you had a chance to look at this version?
I believe all your previous feedback has been addressed and this
version is solid.
Please, let me know your thoughts.

Regards,
Daniel

> There are a few changes since v5 [1]:
>  * Rebased to btrfs/for-next branch.  Couple things changed in the last
>    years.  A few patches were dropped as the code cleaned up or refactored.
>    More details in the patches themselves.
>  * As suggested by Qu and Dave, the on-disk format of storing the extent
>    encryption context was re-designed.  Now, a new tree item with dedicated
>    key is inserted instead of extending the file extent item.  As a result
>    a special care needs to be taken when removing the encrypted extents
>    to also remove the related encryption context item.
>  * Fixed bugs found during testing.
>
> Have a nice day,
> Daniel
>
> [1] v5 https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/
> [2]    https://lore.kernel.org/linux-btrfs/20251112193611.2536093-1-neelx@suse.com/
> [3] v6 https://lore.kernel.org/linux-btrfs/20260206182336.1397715-1-neelx@suse.com/
>
> Josef Bacik (33):
>   fscrypt: add per-extent encryption support
>   fscrypt: allow inline encryption for extent based encryption
>   fscrypt: add a __fscrypt_file_open helper
>   fscrypt: conditionally don't wipe mk secret until the last active user
>     is done
>   blk-crypto: add a process bio callback
>   fscrypt: add a process_bio hook to fscrypt_operations
>   fscrypt: add documentation about extent encryption
>   btrfs: add infrastructure for safe em freeing
>   btrfs: select encryption dependencies if FS_ENCRYPTION
>   btrfs: add fscrypt_info and encryption_type to ordered_extent
>   btrfs: plumb through setting the fscrypt_info for ordered extents
>   btrfs: populate the ordered_extent with the fscrypt context
>   btrfs: keep track of fscrypt info and orig_start for dio reads
>   btrfs: add extent encryption context tree item type
>   btrfs: pass through fscrypt_extent_info to the file extent helpers
>   btrfs: implement the fscrypt extent encryption hooks
>   btrfs: setup fscrypt_extent_info for new extents
>   btrfs: populate ordered_extent with the orig offset
>   btrfs: set the bio fscrypt context when applicable
>   btrfs: add a bio argument to btrfs_csum_one_bio
>   btrfs: limit encrypted writes to 256 segments
>   btrfs: implement process_bio cb for fscrypt
>   btrfs: implement read repair for encryption
>   btrfs: add test_dummy_encryption support
>   btrfs: make btrfs_ref_to_path handle encrypted filenames
>   btrfs: deal with encrypted symlinks in send
>   btrfs: decrypt file names for send
>   btrfs: load the inode context before sending writes
>   btrfs: set the appropriate free space settings in reconfigure
>   btrfs: support encryption with log replay
>   btrfs: disable auto defrag on encrypted files
>   btrfs: disable encryption on RAID5/6
>   btrfs: disable send if we have encryption enabled
>
> Omar Sandoval (6):
>   fscrypt: expose fscrypt_nokey_name
>   btrfs: start using fscrypt hooks
>   btrfs: add inode encryption contexts
>   btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
>   btrfs: adapt readdir for encrypted and nokey names
>   btrfs: implement fscrypt ioctls
>
> Sweet Tea Dorminy (4):
>   btrfs: handle nokey names
>   btrfs: add get_devices hook for fscrypt
>   btrfs: set file extent encryption excplicitly
>   btrfs: add fscrypt_info and encryption_type to extent_map
>
>  Documentation/filesystems/fscrypt.rst |  41 +++
>  block/blk-crypto-fallback.c           |  41 +++
>  block/blk-crypto-internal.h           |   8 +
>  block/blk-crypto-profile.c            |   2 +
>  block/blk-crypto.c                    |   6 +-
>  fs/btrfs/Kconfig                      |   4 +
>  fs/btrfs/Makefile                     |   1 +
>  fs/btrfs/accessors.h                  |   2 +
>  fs/btrfs/backref.c                    |  43 ++-
>  fs/btrfs/bio.c                        | 155 +++++++++-
>  fs/btrfs/bio.h                        |  14 +-
>  fs/btrfs/btrfs_inode.h                |   7 +-
>  fs/btrfs/compression.c                |   6 +
>  fs/btrfs/ctree.h                      |   3 +
>  fs/btrfs/defrag.c                     |  14 +
>  fs/btrfs/delayed-inode.c              |  25 +-
>  fs/btrfs/delayed-inode.h              |   5 +-
>  fs/btrfs/dir-item.c                   | 110 ++++++-
>  fs/btrfs/dir-item.h                   |  10 +-
>  fs/btrfs/direct-io.c                  |  28 +-
>  fs/btrfs/disk-io.c                    |   3 +-
>  fs/btrfs/extent_io.c                  | 115 ++++++-
>  fs/btrfs/extent_io.h                  |   3 +
>  fs/btrfs/extent_map.c                 | 102 ++++++-
>  fs/btrfs/extent_map.h                 |  26 ++
>  fs/btrfs/file-item.c                  |  28 +-
>  fs/btrfs/file-item.h                  |   2 +-
>  fs/btrfs/file.c                       |  79 +++++
>  fs/btrfs/fs.h                         |   6 +-
>  fs/btrfs/fscrypt.c                    | 413 ++++++++++++++++++++++++++
>  fs/btrfs/fscrypt.h                    |  86 ++++++
>  fs/btrfs/inode.c                      | 404 +++++++++++++++++++------
>  fs/btrfs/ioctl.c                      |  41 ++-
>  fs/btrfs/ordered-data.c               |  35 ++-
>  fs/btrfs/ordered-data.h               |  14 +
>  fs/btrfs/reflink.c                    |  43 ++-
>  fs/btrfs/root-tree.c                  |   9 +-
>  fs/btrfs/root-tree.h                  |   2 +-
>  fs/btrfs/send.c                       | 134 ++++++++-
>  fs/btrfs/super.c                      |  99 +++++-
>  fs/btrfs/super.h                      |   3 +-
>  fs/btrfs/sysfs.c                      |   6 +
>  fs/btrfs/tree-checker.c               |  64 +++-
>  fs/btrfs/tree-log.c                   |  34 ++-
>  fs/btrfs/volumes.c                    |   5 +
>  fs/crypto/crypto.c                    |  10 +-
>  fs/crypto/fname.c                     |  36 ---
>  fs/crypto/fscrypt_private.h           |  51 +++-
>  fs/crypto/hooks.c                     |  38 ++-
>  fs/crypto/inline_crypt.c              |  91 +++++-
>  fs/crypto/keyring.c                   |  18 +-
>  fs/crypto/keysetup.c                  | 164 ++++++++++
>  fs/crypto/policy.c                    |  47 +++
>  include/linux/blk-crypto.h            |  15 +-
>  include/linux/fscrypt.h               | 127 ++++++++
>  include/uapi/linux/btrfs.h            |   1 +
>  include/uapi/linux/btrfs_tree.h       |  26 +-
>  57 files changed, 2665 insertions(+), 240 deletions(-)
>  create mode 100644 fs/btrfs/fscrypt.c
>  create mode 100644 fs/btrfs/fscrypt.h
>
> --
> 2.53.0
>

