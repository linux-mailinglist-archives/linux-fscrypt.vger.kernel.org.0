Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E47213B3D3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jan 2020 21:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgANUxF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jan 2020 15:53:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbgANUxF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jan 2020 15:53:05 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE40424658;
        Tue, 14 Jan 2020 20:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579035184;
        bh=dWFV1rQEEHUES8wogtbPNvElhFB6O8ae0mbTSi6jKOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y/FSVY25SMw7PXx3BqqMjdQ0+5cROkvI/j2QcjGMitiT4AC+nJrghZ/prHqJUkrQe
         JBKMRFB0A5r5OAAL+JzG9VxnMvJ+KNLobmXqFS4V+lGnzfIPF9hXz3eNfuFVl8Ienn
         XrIel7kvaE1cuqzWWzHPOLV9673viHmNArLCx5Lc=
Date:   Tue, 14 Jan 2020 12:53:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fscrypt: optimize fscrypt_zeroout_range()
Message-ID: <20200114205302.GA41220@gmail.com>
References: <20191226160813.53182-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226160813.53182-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 26, 2019 at 10:08:13AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently fscrypt_zeroout_range() issues and waits on a bio for each
> block it writes, which makes it very slow.
> 
> Optimize it to write up to 16 pages at a time instead.
> 
> Also add a function comment, and improve reliability by allowing the
> allocations of the bio and the first ciphertext page to wait on the
> corresponding mempools.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/bio.c | 112 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 81 insertions(+), 31 deletions(-)

Applied to fscrypt.git#master for 5.6.

- Eric
