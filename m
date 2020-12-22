Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B95F2E0E49
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 19:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgLVSlD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Dec 2020 13:41:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgLVSlD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Dec 2020 13:41:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17754229C5;
        Tue, 22 Dec 2020 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608662423;
        bh=xv9w7bdUiLXk5NN0QEkRmRYjDDxt76AB17MXjZ9iWFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fcEbjeB+NqAsuZLMcUs5YKPymvTt11/ryuPLQdGkztVWmEJPjcWUeGWOXKxf7D1CC
         6+4ThVZBxZ3nuHvbxYx1L+E9pb2ts2tV5hdKE38z2mE+7INymAcOEQKN42MMjKV5Qc
         qzszmOot8dYVK+zEXsd1h9LT6SNbmt3uXY4xtWIN39/ptPd576jUKIxZxYBQUZrmxY
         92PDqIIi6UItNvNHuq4ctMaWZCVMtPrC3yldsSyhlrrR/bXSq6/F8zCtjndpGpuHIU
         C6L88I7LkpA+hkCcL4pq5geDId0Ff/Ztt15rMpvy8qVBKLNeqrQoJ43NIp11BnJnJh
         4MDXoMxtjXOKg==
Date:   Tue, 22 Dec 2020 10:40:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Move -D_GNU_SOURCE to CPPFLAGS
Message-ID: <X+I9lYYXI6lcU/IO@sol.localdomain>
References: <20201221232428.298710-1-bluca@debian.org>
 <20201222001033.302274-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222001033.302274-1-bluca@debian.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 22, 2020 at 12:10:31AM +0000, Luca Boccassi wrote:
> Use _GNU_SOURCE consistently in every file rather than just one file.
> This is needed for the Windows build in order to consistently get the MinGW
> version of printf.
> 
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
> v6: split from mingw patch
> 
> v7: adjust commit message and add CPPFLAG to run-sparse.sh as well
> 
>  Makefile              | 2 +-
>  lib/utils.c           | 2 --
>  scripts/run-sparse.sh | 2 +-
>  3 files changed, 2 insertions(+), 4 deletions(-)
> 

Applied, thanks.

- Eric
