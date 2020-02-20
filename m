Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7156D166679
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Feb 2020 19:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgBTSmO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Feb 2020 13:42:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48828 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgBTSmO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Feb 2020 13:42:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KIVT1Y039035;
        Thu, 20 Feb 2020 18:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=a1asEzhbilF9Kwo+cqEtCdusoeP8zcYAj6pxvuwmcUI=;
 b=kUYMZYzxi3/nMDS06nkmblwmx591ZLNWe/yUrgxvcZfhgC2i+H2FV4CZ5+w3cF6qiurn
 DsZVpGnNj8D+qUj7WJnt0xwbFcCyBjmBpLXxXcNppVr+7jerevR4Sq2Zk5XwNlAUJk0R
 i4/ES1QXe1OF9lzHAD1ChIv4OzouL9Cs79BTq2mNhWhjfzvJ1j8hzSDcM0wcNrX1sgSE
 o+EH8r465/Mi32SpXh4dhK9OALdcc0BjIU6U6eno1LJZhUSMzF2gqWucuqO1mop/pGdE
 yGS9SByzwY92mSTWiopJYffAWpCqIxAW9ekn5YPjdgn/H4H4ytTBxKaZjLCS5SuWxN9m 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udkkqpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 18:42:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01KISPSj061497;
        Thu, 20 Feb 2020 18:42:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8uddc5x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 18:42:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01KIg8BC007772;
        Thu, 20 Feb 2020 18:42:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Feb 2020 10:42:07 -0800
Date:   Thu, 20 Feb 2020 10:42:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org
Subject: Re: [PATCH v2] xfs_io/encrypt: support passing a keyring key to
 add_enckey
Message-ID: <20200220184206.GB9506@magnolia>
References: <20200203182013.43474-1-ebiggers@kernel.org>
 <20200218214856.GA147283@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218214856.GA147283@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=9 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=9
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200136
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Feb 18, 2020 at 01:48:57PM -0800, Eric Biggers wrote:
> On Mon, Feb 03, 2020 at 10:20:13AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a '-k' option to the 'add_enckey' xfs_io command to allow exercising
> > the key_id field that is being added to struct fscrypt_add_key_arg.
> > 
> > This is needed for the corresponding test in xfstests.
> > 
> > For more details, see the corresponding xfstests patches as well as
> > kernel commit 93edd392cad7 ("fscrypt: support passing a keyring key to
> > FS_IOC_ADD_ENCRYPTION_KEY").
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > No changes since v1.
> > 
> > This applies to the for-next branch of xfsprogs.
> > 
> >  configure.ac          |  1 +
> >  include/builddefs.in  |  4 ++
> >  io/encrypt.c          | 90 +++++++++++++++++++++++++++++++------------
> >  m4/package_libcdev.m4 | 21 ++++++++++
> >  man/man8/xfs_io.8     | 10 +++--
> >  5 files changed, 98 insertions(+), 28 deletions(-)
> > 
> 
> Any comments on this patch?  The corresponding xfstests patches were merged.

I didn't see any obvious bugs, though fwiw I'm not that familiar with
fscrypt.  This looks like a pretty straightforward addition of a new
field to a kernel call structure and some other plumbing to fill out the
new field with CLI arguments / stdin.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> - Eric
