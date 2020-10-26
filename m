Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E443299815
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 21:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388576AbgJZUg5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 16:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388574AbgJZUg5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 16:36:57 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA50207E8;
        Mon, 26 Oct 2020 20:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603744617;
        bh=lVNZ9tZpJj8tOLtYSmS7+ET3s0QqXnjRY+Yc+jxmWYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SF+8Y2CTEyYpaZICGJWDBdsx53iGp5Ab7bZir/+1x/RTSdLLxLS4Ej6L/2rBDo1N8
         mMlI0vganvGIHKZJ3Cei0Jw1tx9V8HeAs6bciK1DY/LkBOwkBdR2uawUnqIsE/7swj
         Ss1IWtrHk+IAn8t2kEPZYuWi6TEmZlCWXuklvH54=
Date:   Mon, 26 Oct 2020 13:36:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v5] Add digest sub command
Message-ID: <20201026203655.GN858@sol.localdomain>
References: <20201026181729.3322756-1-luca.boccassi@gmail.com>
 <20201026191839.3329948-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026191839.3329948-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 26, 2020 at 07:18:39PM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Add a digest sub command that prints a hex-encoded digest of
> a file, ready to be signed offline (ie: includes the full
> data that is expected by the kernel - magic string, digest
> algorithm and size).
> 
> Useful in case the integrated signing mechanism with local cert/key
> cannot be used.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>

Applied with a few tweaks.  Thanks!

- Eric
