Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C0E3908A3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 May 2021 20:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhEYSP2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 May 2021 14:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhEYSP1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 May 2021 14:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDFF1613FA;
        Tue, 25 May 2021 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621966437;
        bh=xqXGGPAcXK7wu9183d9xpKdxb1a8fN54+STNUIljgYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MGRTPOwCNTYTnbGTfRNWNpHs5dfPc60A0ASz/mGrECYW3vjGsfqr03mecWcqVJW48
         o0yVnjiRww5y7Ps3kJEsOe3p0YDP0Po2Ui6CA4CZfVZO/r9sTKtcr0vqKQ2yb5Oe7U
         /e5hW/J02O7mDe1q+TTF+Bs3Rd+mZl+kw+j0r1+mgmPoK+96jKj+ZOvrvmvRsW50uO
         u7GePPzwZ+3IxURHY+sajJm5Z0XFJzaY87fqboPYJhSK9K9l3S/mu8CQE8ZGFuS+M+
         YiB+HJTEKaJeNDLn1KqcLb+43L0lcWDXFDVQe1EkzwoDgZOq5h2sX3X9lGjishrkzK
         l37iDdsYqzEMA==
Date:   Tue, 25 May 2021 11:13:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 0/4] tests for btrfs fsverity
Message-ID: <YK0+ZLeMwB2RJy2f@sol.localdomain>
References: <cover.1620248200.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1620248200.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 02:04:42PM -0700, Boris Burkov wrote:
> This patchset provides tests for fsverity support in btrfs.
> 
> It includes modifications for generic tests to pass with btrfs as well
> as new tests.
> 

Can you please mention which xfstests commit this patchset applies to?

- Eric
