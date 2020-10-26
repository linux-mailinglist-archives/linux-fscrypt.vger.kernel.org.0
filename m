Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271562993E2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408007AbgJZRcu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 13:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407989AbgJZRcu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 13:32:50 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F8020732;
        Mon, 26 Oct 2020 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603733570;
        bh=GLblBaIKJ250AYM+WK/Coq796M6Lo6RckFCNlVWzoXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KpdWjwntnhhrWOwlOeUsiTNT19CmBWjQMB6DMBHrFxj9dSCyubLBdf8SBmwtHMKkm
         B/nKWfO4vU+kSXouBxm1wJwnreBSStWrkmhYdmptSxff94dTE/yhS0jK2TBbniUdmH
         bgccQrY0wURmknxQrIYd3VQTRWUjQas6+6hrzCEo=
Date:   Mon, 26 Oct 2020 10:32:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v2 2/2] Generate and install libfsverity.pc
Message-ID: <20201026173249.GE858@sol.localdomain>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
 <20201026111506.3215328-1-luca.boccassi@gmail.com>
 <20201026111506.3215328-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026111506.3215328-2-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 26, 2020 at 11:15:06AM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> pkg-config is commonly used by libraries to convey information about
> compiler flags and dependencies.
> As packagers, we heavily rely on it so that all our tools do the right
> thing by default regardless of the environment.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>

Applied with a couple fixups.  Thanks!

- Eric
