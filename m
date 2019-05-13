Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA6A1BF29
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 May 2019 23:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfEMVjG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 May 2019 17:39:06 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:47890 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfEMVjG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 May 2019 17:39:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id B5A626083107;
        Mon, 13 May 2019 23:39:04 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id d0hL8uthwQhf; Mon, 13 May 2019 23:39:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 6C6886083108;
        Mon, 13 May 2019 23:39:04 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CtxwwqacyvI0; Mon, 13 May 2019 23:39:04 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 3FC4A6083107;
        Mon, 13 May 2019 23:39:04 +0200 (CEST)
Date:   Mon, 13 May 2019 23:39:04 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-fscrypt <linux-fscrypt@vger.kernel.org>,
        tytso <tytso@mit.edu>, kernel <kernel@pengutronix.de>
Message-ID: <1886500245.56511.1557783544203.JavaMail.zimbra@nod.at>
In-Reply-To: <20190513195652.GB142816@gmail.com>
References: <20190326075232.11717-1-s.hauer@pengutronix.de> <20190326075232.11717-2-s.hauer@pengutronix.de> <20190508031954.GA26575@sol.localdomain> <1170873772.48849.1557298158182.JavaMail.zimbra@nod.at> <20190513195652.GB142816@gmail.com>
Subject: Re: [PATCH 1/2] ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.8_GA_3025 (ZimbraWebClient - FF60 (Linux)/8.8.8_GA_1703)
Thread-Topic: ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION
Thread-Index: wzeulKMKcqRRx0r0yyIy5nwtrOQ2UA==
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

----- Ursprüngliche Mail -----
> This was merged to mainline and it's still broken.  This breaks UBIFS encryption
> entirely, BTW.  Do you not run xfstests before sending pull requests?

The simple answer is, not this time because my Laptops' filesystem broke
and I was kind of busy with recovery.
The issue is known, we have a patch and fixup will be sent to Linus
very soon. Nobody got hurt.

Thanks,
//richard
