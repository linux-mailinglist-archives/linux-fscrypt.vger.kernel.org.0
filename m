Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0CF412D77
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Sep 2021 05:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhIUDcP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Sep 2021 23:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhIUDSi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Sep 2021 23:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4571561100
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Sep 2021 03:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632194231;
        bh=UCOoVrpfpYThM2V9d/6Gjpe+3mWD9/ksEf3cISFDlls=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=X939MksIrdK+8/J1gP4aseWjNtxoXd3h1GqnlDmslKIsDBwQNuFTxaAD65F/ZmwM5
         epkIdY1bbdCAxBOvVyi5Jpye3Gnbzf0iJVinotZVxrsuIB+Nnb4UUoNPwTsxuVouGT
         7QICkDZA+9LxDNj8EcApe7B17gG9ZpijhUnGwtllc/vnx8phuucYkljLgcCO1jxi0Y
         Kj/YLIi1aThpwM4ZnIzX6Yf36Q6Ya0xhSrdZ4wqYjx38Z8MC7VGbI8Dbs8t+0JeHrh
         qRV7ugzD2Vl6zX1bjJzjK8DCDVDvDGRiltSz5e3rjN1PjTugSmurCNoi+yVVGO1tZy
         n0G4Naw+LPTQw==
Date:   Mon, 20 Sep 2021 20:17:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: clean up comments in bio.c
Message-ID: <YUlOtslSectFI2q+@sol.localdomain>
References: <20210909190737.140841-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909190737.140841-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 09, 2021 at 12:07:37PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The file comment in bio.c is almost completely irrelevant to the actual
> contents of the file; it was originally copied from crypto.c.  Fix it
> up, and also add a kerneldoc comment for fscrypt_decrypt_bio().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/bio.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)

Applied to fscrypt.git#master for 5.16.

- Eric
