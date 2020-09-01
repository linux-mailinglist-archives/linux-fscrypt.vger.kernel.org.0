Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0D2597BC
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Sep 2020 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgIAQRw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 1 Sep 2020 12:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgIAQR2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 1 Sep 2020 12:17:28 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 168AA2065F;
        Tue,  1 Sep 2020 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598977048;
        bh=aQDY+GZCG0gO8INMzisB91pBqMk6XL7dm/EYHBpeXgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ihqdVMdA2XmwZygppSUax6l9V6qWOlKI77NxNyPPUz1dPR3UozilvGAPDqpeEzLHt
         yUVlptwFjhu2hTRwHBhxkDJY0Nh5DE68DM+ylhdllYE3/IsMnBv3u4YYqoxwupDmZh
         iJsqnvyW5OKFHr3gUEtQtJxgxS1rxmxHnmy8s2zM=
Date:   Tue, 1 Sep 2020 09:17:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Satya Tangirala <satyat@google.com>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests-bld PATCH v2] test-appliance: exclude generic/587 from
 the encrypt tests
Message-ID: <20200901161726.GB669796@gmail.com>
References: <20200709184145.GA3855682@gmail.com>
 <20200709185832.2568081-1-satyat@google.com>
 <20200709191031.GB3855682@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709191031.GB3855682@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 09, 2020 at 12:10:31PM -0700, Eric Biggers wrote:
> On Thu, Jul 09, 2020 at 06:58:32PM +0000, Satya Tangirala wrote:
> > The encryption feature doesn't play well with quota, and generic/587
> > tests quota functionality.
> > 
> > Signed-off-by: Satya Tangirala <satyat@google.com>
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Ted, are you planning to apply this?
