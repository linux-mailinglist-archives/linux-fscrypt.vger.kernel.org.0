Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D578F2777DE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Sep 2020 19:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbgIXRcx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Sep 2020 13:32:53 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49928 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728563AbgIXRcw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Sep 2020 13:32:52 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2020 13:32:52 EDT
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 08OHRTu1014389
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Sep 2020 13:27:29 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2C7CF42003C; Thu, 24 Sep 2020 13:27:29 -0400 (EDT)
Date:   Thu, 24 Sep 2020 13:27:29 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Satya Tangirala <satyat@google.com>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests-bld PATCH v2] test-appliance: exclude generic/587 from
 the encrypt tests
Message-ID: <20200924172729.GI482521@mit.edu>
References: <20200709184145.GA3855682@gmail.com>
 <20200709185832.2568081-1-satyat@google.com>
 <20200709191031.GB3855682@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709191031.GB3855682@gmail.com>
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

Applied, thanks

						- Ted
