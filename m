Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367D713B3F7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jan 2020 22:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgANVEH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jan 2020 16:04:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgANVEG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jan 2020 16:04:06 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E1CB24658;
        Tue, 14 Jan 2020 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579035845;
        bh=VdbS8mEmXSpt9DK0Rzc+X41XsKnqVc8X/04G/OEHIcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OuS9j6Dv1EvS0E04zyTTEBxvfQP23u+RUjEOR6p5OmiKLuXkKThrzdUlVBuIyor6F
         TT6g0e50F1cf3gdtPor6Y2yG6LozIjmuUZCo2LJS2Gzi5wYtQkc808bRarxk98LdpE
         S3SZK/dYhtrW7smV92leXPZZPGJNbW6h7RCqKe74=
Date:   Tue, 14 Jan 2020 13:04:04 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fscrypt: document gfp_flags for bounce page allocation
Message-ID: <20200114210403.GB41220@gmail.com>
References: <20191231181026.47400-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231181026.47400-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 31, 2019 at 12:10:26PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Document that fscrypt_encrypt_pagecache_blocks() allocates the bounce
> page from a mempool, and document what this means for the @gfp_flags
> argument.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/crypto.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied to fscrypt.git#master for 5.6.

- Eric
