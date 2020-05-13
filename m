Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76FE1D0539
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2020 05:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgEMDGa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 May 2020 23:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgEMDGa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 May 2020 23:06:30 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49BB12176D;
        Wed, 13 May 2020 03:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589339190;
        bh=6a9BGuNMOSYRQS1ZxzXqpxbWopV28GpPsuZDDKjLf68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBJ5YQv7zqIJqlTjbjaek7JZn8sJW0TLMnzrCErzt8wrRpY3oPrNjyxb0OPeeMqSk
         J7mESAq77RDWvpR4KYxFwjufOwYWSMjMRikq8ikdt6xIqRsUf1E8LNfMFo0hyAabxQ
         F+wijFS5G4ipYowVWG4YYuPKAKHqAiVwa0ui+PRA=
Date:   Tue, 12 May 2020 20:06:29 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH 1/4] linux/parser.h: add include guards
Message-ID: <20200513030629.GA108075@google.com>
References: <20200512233251.118314-1-ebiggers@kernel.org>
 <20200512233251.118314-2-ebiggers@kernel.org>
 <20200513005355.GE1596452@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513005355.GE1596452@mit.edu>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 05/12, Theodore Y. Ts'o wrote:
> On Tue, May 12, 2020 at 04:32:48PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > <linux/parser.h> is missing include guards.  Add them.
> > 
> > This is needed to allow declaring a function in <linux/fscrypt.h> that
> > takes a substring_t parameter.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
