Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BE9260709
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Sep 2020 00:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgIGWvy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Sep 2020 18:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgIGWvx (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Sep 2020 18:51:53 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0668121473;
        Mon,  7 Sep 2020 22:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599519113;
        bh=qow4/cZPIqfrydocDClnY9AoIUGhX2rllTat0rDAaeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VMDxdMzHhBsVlSMiqfcgphgXB/aBL8oWR+gBy2nsz7elAn3eb9rn86M3fyvxGq3Hx
         r6jGw228WE0dnRO/KhzV+TJ7xT6kNwgWN5SF2Xs7ClBxQTRrwS600O4a9dbM3xh3mt
         t8En8ZEdJ06qQUfC7HHGwv5VzTEptet+nRRy0h4w=
Date:   Mon, 7 Sep 2020 15:51:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jeff Layton <jlayton@kernel.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH] fscrypt: restrict IV_INO_LBLK_32 to ino_bits <= 32
Message-ID: <20200907225151.GC68127@sol.localdomain>
References: <20200824203841.1707847-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824203841.1707847-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 24, 2020 at 01:38:41PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When an encryption policy has the IV_INO_LBLK_32 flag set, the IV
> generation method involves hashing the inode number.  This is different
> from fscrypt's other IV generation methods, where the inode number is
> either not used at all or is included directly in the IVs.
> 
> Therefore, in principle IV_INO_LBLK_32 can work with any length inode
> number.  However, currently fscrypt gets the inode number from
> inode::i_ino, which is 'unsigned long'.  So currently the implementation
> limit is actually 32 bits (like IV_INO_LBLK_64), since longer inode
> numbers will have been truncated by the VFS on 32-bit platforms.
> 
> Fix fscrypt_supported_v2_policy() to enforce the correct limit.
> 
> This doesn't actually matter currently, since only ext4 and f2fs support
> IV_INO_LBLK_32, and they both only support 32-bit inode numbers.  But we
> might as well fix it in case it matters in the future.
> 
> Ideally inode::i_ino would instead be made 64-bit, but for now it's not
> needed.  (Note, this limit does *not* prevent filesystems with 64-bit
> inode numbers from adding fscrypt support, since IV_INO_LBLK_* support
> is optional and is useful only on certain hardware.)
> 
> Fixes: e3b1078bedd3 ("fscrypt: add support for IV_INO_LBLK_32 policies")
> Reported-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt.git#master for 5.10.

- Eric
