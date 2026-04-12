Return-Path: <linux-fscrypt+bounces-1544-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOhHMEzl2mn26wgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1544-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Apr 2026 02:20:28 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D483E2204
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Apr 2026 02:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 13553300F109
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Apr 2026 00:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFDD423AB81;
	Sun, 12 Apr 2026 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E7/hKr8W"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB49E1A2C04;
	Sun, 12 Apr 2026 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775953177; cv=none; b=rgIrNtXEyP/Nr4VvNcdYRQgUWa/DaJBHZ/WxqIvjVeIEEb84j8vvQuhdstb0PyYGQKJJPk8VkgW84VapTp63j+1eBxO3zs3Tv6k/oxT8JO9zEBXXgDptNZvCGWDSw5U6w3MruiYiVvvXO7fzpz3RxKReC5guTKGNk2X+3F/Ibd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775953177; c=relaxed/simple;
	bh=bHcod1uxP1ivKIc/+dttd5Ip/4XLZ0zlpJ4vYMeOYgw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=b+tnfTyfbxadYXi1c3tBQ104t2PYfTePKVO3ufCXmY31aPrqP50fB0ge5aG97ukgjv5g8mGZeMWLYSHwXdSbNivRvF33ikXEqCVtDywg9K/DsxZtMrqNB/HdUlDYtt7k9OLbzBBBN0/vXSKmewsjlaXNlHA2DOhHZvPEaEcrBRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E7/hKr8W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B28C19425;
	Sun, 12 Apr 2026 00:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775953177;
	bh=bHcod1uxP1ivKIc/+dttd5Ip/4XLZ0zlpJ4vYMeOYgw=;
	h=Date:From:To:Cc:Subject:From;
	b=E7/hKr8WOoaKcB8CXqmH1Psj6fKTj4JHkgdWgP/3jp75hiOIkbD42uE28515Qaux+
	 52Qh4wZOstcto7UR19Wo/Axpo4CT2ZKgFWRbdPwwzNhCiprzCAc3shLuL3ZhtuzeAs
	 3Z/+R3Nd7IVLf2hShVtLnlxZE26zeRkvnjm6nW/50aBxZIQOVil+5RepV0eyMfml6N
	 1njr9Sg5Ezphu+4qcNSBEeMqQfq68721u1R4we26tyKhpSZLChloYgKLCLVk/6N+5R
	 F9Vta5A99OPzUjtR75w3wLGwS2yqZDs35y/M+JLts8wYEhHITl8ZEf76pZtY7MYuR8
	 ht9FVghpcf2Rw==
Date: Sat, 11 Apr 2026 17:18:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] fscrypt updates for 7.1
Message-ID: <20260412001820.GA6632@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1544-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 20D483E2204
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The following changes since commit 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681:

  Linux 7.0-rc3 (2026-03-08 16:56:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus

for you to fetch changes up to 1546d3feb5e533fbee6710bd51b2847b2ec23623:

  fscrypt: use AES library for v1 key derivation (2026-03-25 12:06:33 -0700)

----------------------------------------------------------------

- Various cleanups for the interface between fs/crypto/ and
  filesystems, from Christoph Hellwig

- Simplify and optimize the implementation of v1 key derivation by
  using the AES library instead of the crypto_skcipher API

----------------------------------------------------------------
Christoph Hellwig (14):
      ext4: initialize the write hint in io_submit_init_bio
      ext4: open code fscrypt_set_bio_crypt_ctx_bh
      ext4: factor out a io_submit_need_new_bio helper
      ext4, fscrypt: merge fscrypt_mergeable_bio_bh into io_submit_need_new_bio
      fscrypt: move fscrypt_set_bio_crypt_ctx_bh to buffer.c
      fscrypt: pass a byte offset to fscrypt_generate_dun
      fscrypt: pass a byte offset to fscrypt_mergeable_bio
      fscrypt: pass a byte offset to fscrypt_set_bio_crypt_ctx
      fscrypt: pass a byte offset to fscrypt_zeroout_range_inline_crypt
      fscrypt: pass a byte length to fscrypt_zeroout_range_inline_crypt
      fscrypt: pass a byte offset to fscrypt_zeroout_range
      fscrypt: pass a byte length to fscrypt_zeroout_range
      fscrypt: pass a real sector_t to fscrypt_zeroout_range
      ext4: use a byte granularity cursor in ext4_mpage_readpages

Eric Biggers (1):
      fscrypt: use AES library for v1 key derivation

 fs/buffer.c                 | 18 +++++++++-
 fs/crypto/Kconfig           |  2 +-
 fs/crypto/bio.c             | 38 +++++++++-----------
 fs/crypto/fscrypt_private.h |  3 --
 fs/crypto/inline_crypt.c    | 86 +++++---------------------------------------
 fs/crypto/keysetup.c        |  2 --
 fs/crypto/keysetup_v1.c     | 87 +++++++++++++++------------------------------
 fs/ext4/inode.c             |  5 ++-
 fs/ext4/page-io.c           | 28 +++++++++++----
 fs/ext4/readpage.c          | 10 +++---
 fs/f2fs/data.c              |  7 ++--
 fs/f2fs/file.c              |  4 ++-
 fs/iomap/direct-io.c        |  6 ++--
 include/linux/fscrypt.h     | 37 +++++--------------
 14 files changed, 120 insertions(+), 213 deletions(-)

