Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC3F145EE0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Jan 2020 23:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVW7d (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Jan 2020 17:59:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgAVW7c (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Jan 2020 17:59:32 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45B4524673
        for <linux-fscrypt@vger.kernel.org>; Wed, 22 Jan 2020 22:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579733972;
        bh=1sDy2CEonQ2CDQ4Hx29hJArtAHi6z3mdfC5C83k906c=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=YkDeofPLjGUQONTXu072vyrwSQ02CbKTguM4XgfP4CCNPXUj5ItpkAzrYfRSUVFmP
         LGyGya/VzBkJjrVmejZiHeF7Qq+cVEbe9CseMG4867qCXPx3ccdkaoZ0qL7PEK9e5V
         Fnd79UboneHpLsxhTY1TdStZ2MDIXJIKxxd2StNg=
Date:   Wed, 22 Jan 2020 14:59:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: add "fscrypt_" prefix to fname_encrypt()
Message-ID: <20200122225930.GB182745@gmail.com>
References: <20200120071736.45915-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120071736.45915-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 19, 2020 at 11:17:36PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fname_encrypt() is a global function, due to being used in both fname.c
> and hooks.c.  So it should be prefixed with "fscrypt_", like all the
> other global functions in fs/crypto/.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fname.c           | 10 +++++-----
>  fs/crypto/fscrypt_private.h |  5 +++--
>  fs/crypto/hooks.c           |  3 ++-
>  3 files changed, 10 insertions(+), 8 deletions(-)
> 

Applied to fscrypt.git#master for 5.6.

- Eric
