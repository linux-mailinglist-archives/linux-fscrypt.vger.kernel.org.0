Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7AA405EB9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 23:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346871AbhIIVXK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Sep 2021 17:23:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346551AbhIIVXK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Sep 2021 17:23:10 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 189LG0kF011916
        for <linux-fscrypt@vger.kernel.org>; Thu, 9 Sep 2021 14:22:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=IAeiGMWgnZO62f1wYRphqwIRleAjvAvhUj6O551/KNc=;
 b=jaROG03An19qF5vDzpIjipkWX4ddLQJUmrmembfQlwVQYQusH9sm7gsdnIeV1GEoE5pi
 HswhyYlY/G0U17vo3eamafl52oPYKaMRrce2KjbdNAIJAfnOpPXDkYD2D8DxfgXjtScV
 WsrFDY+Rob6MojZk7p8e+7B0kHrZFgx4GCE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aya9h66mn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Sep 2021 14:22:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 9 Sep 2021 14:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cs9cBLZqHtqysRBa9VE52FI/N8Rv50Q2/l4uyBEcn9ZJr6vLP9YYEWP2zpdHBtu6YwQGnAeLkMzrEOQyn3rpj1cW+LXVcLrZZpINZ7pRK8a/N5YhongTGNiMhEa55OiM3UHzvs4g6GHktPSfZXLPtlvvdxThRqW7/N++Wia+JS5GT0evAc63VTZV/EeLplsVDQt4ZsijaiMnsCu3yA7eQjJvb2oj+xvkdOgwGZKofGhxMAYlkGqmauYWxDOgUkrV3lT7psYOWda76Yk7PnsmQ37gi9pKj9YLOckO5I38q2coZwP8EJuNYy7iNvjWu5JuBOq5hpkO42xar3yUOYiC3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IAeiGMWgnZO62f1wYRphqwIRleAjvAvhUj6O551/KNc=;
 b=akEAimdIS5qUOWTtBsrt98GbDWmPJbdUnMuPmDERZNHpOAMhu83Zl8r2Et5QZR/F6cttdz6r37SJTrDJfOLvsJzRymvSCf+Rh+02lj+EEIkAx5wC45Dna8eguiz+gFdNMnlAlFLQOaewe8LOlO8tGBeM69HuW3ak1143GMjSVH6BCJnDoGH6W8A3Vj4bFuxM9YiHHiRG1x37zO8eknbpenqU+rf8hE3Sbw5QMbnysgLRgi1ioFcWF+XXWYWgzS3FLBbBWIm3wYe+y19wVj0pAuowGPXuf0BIBYI5iXZy0CQhF/t+7c1M6zMc06LZAqbdacvVBDCrkEL1cca1TFROeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4824.namprd15.prod.outlook.com (2603:10b6:806:1e3::15)
 by SA1PR15MB4984.namprd15.prod.outlook.com (2603:10b6:806:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 21:21:52 +0000
Received: from SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7]) by SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7%8]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 21:21:52 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH v4] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Topic: [fsverity-utils PATCH v4] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Index: AQHXpRW/fVgmI0/fk0emaLxX2+uSaqubTUcAgADocKo=
Date:   Thu, 9 Sep 2021 21:21:52 +0000
Message-ID: <SA1PR15MB482423A29504AFD4EE0C8BF3DDD59@SA1PR15MB4824.namprd15.prod.outlook.com>
References: <20210909005734.154434-1-olo@fb.com>
 <YTmqoDtXXFbwHM/4@sol.localdomain>
In-Reply-To: <YTmqoDtXXFbwHM/4@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 64f1924d-4212-409c-3847-e1722a00b470
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72925e8d-0a0c-45b4-695b-08d973d7d7c3
x-ms-traffictypediagnostic: SA1PR15MB4984:
x-microsoft-antispam-prvs: <SA1PR15MB49846DDB4DA8874F0C583DD8DDD59@SA1PR15MB4984.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7fggghTSCxIBoyE524i62aE2x4gZUdxTbLZ+8HH8huqqssj7L7Rwah20NOc+nBo/rd9ZCfd95fvmCYJUz+WG8+Qo5JoVhL9dPXCpi35drZlp+44Q3zaj/AhLBE0TAOzRK6eQV1Nf1+OIJLcBP/oL/qbgmNuyGl33pPS1k7Nx9UbsHv0t+UjAyiGcq8onZXAGOqAP2GW2ZCXyND+iExJNvPXpl2YXwg9aWYGwdHFjfjANZw+HUqyShlatqDhCioNYndK11fuWmYYem8UrmBMnKscXKZ/XHDtABnAUIaTRw8+qBxQxjtd2kt0wY3paoGZrDiKNL5u24b0EgogzkRb+71fHG0Vyd+PfmcZ+sbz9+VhF7bzigE38xXdI9P4N+kmfkyS3TxVuoy9dmCvIEtmaKZOBJGfdZXuEt/pMrv3wkz1JFXf7hDlBi1qXXPHNe33S0v3lBTelvGjWg0iIEq1s19tK3I+xsfK8sgEMyjy6dbm9ISGUCMZJF74SQ8XvVJiju5EZCrWAE2QPkHURKh3bt8OI2SXepHxO+nxmeV38/Cn1QcnnnQZZOG7/PBrL44hVcviTyfnWto7BKuqef05aGzz9APHyLndCM6jn523j+VjfOAQ9bCMNiniTpmdKioGRlZEkWsD7pp7aCEi4zP8BcYMwKyRx1wLWBoXhieGLK1cKc9KCAWEI89DLgZm9pp+ROGSe9sv/YOjCbgcgfqCiYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4824.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(5660300002)(86362001)(33656002)(71200400001)(2906002)(122000001)(8676002)(38100700002)(316002)(55016002)(186003)(66946007)(76116006)(4326008)(91956017)(66446008)(64756008)(6506007)(38070700005)(6916009)(8936002)(66556008)(66476007)(9686003)(4744005)(83380400001)(52536014)(478600001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+tAp6snMygQ9kPGn/sBVCQlgR8Mz6ZUMDLdSXXIBIsOTDlPWh3qpKgUIHP?=
 =?iso-8859-1?Q?Kc2LomSEqAbjy82Q9ClGjuHUs3/vRZLMGFr205jRWFvcq7DjMHzhNh/B+n?=
 =?iso-8859-1?Q?MKxuX8ihRJjEibjxXhilmB5fI+i11oBdHiqeu3GBXf6lcPxlPxwkCCLQ9f?=
 =?iso-8859-1?Q?XRvLaoYlW1QSLnI8WonbMcHKcCCvJPqTcjZ7H2xgz/SnY9dHvAVIoQAg4M?=
 =?iso-8859-1?Q?vqk7Zw10L+GZTABETi6Z53AJt4PL2NEhYv8eT8S03C8USWOPu8ZJqCXJ/V?=
 =?iso-8859-1?Q?pePxzpUHEiQZAKjP0xfL7mr1sqGzEN39UwO7xB5gwBJrqI5bWXsem+1zt4?=
 =?iso-8859-1?Q?DmHnkchhnLRh4LKrA5c8eQMMzfCDOJXJVIBuDKq68zzQBJ6lRaHXKmCH5A?=
 =?iso-8859-1?Q?iGVxyP0rX0/fErSrE2bSQzmdTFtYM/Go6X5jTtcP4TO8x4LD1ZKyvRh9op?=
 =?iso-8859-1?Q?aWDvFam8H0+0ZRMjSkOcE6fqBXDk2L8tJEsVu2SLkXvKSGZsIAqwZvNejt?=
 =?iso-8859-1?Q?3fEe+PGv3mHJDDgjgkpaaYtopD9IAPwYpD++aEXg2S3hXwEDf7bOt/toPM?=
 =?iso-8859-1?Q?MbSDb+BW1J6/T7/kQAx5MKZ2uBqnZbc68cC8pPLh9/H9Ew8DAyrtfGWABJ?=
 =?iso-8859-1?Q?K3Y64VmGdMSat8dqLNcQ/G/s8BOKOSU6MPkmby0JdwKW8ARfNTG64xN45W?=
 =?iso-8859-1?Q?c2zemYtnAXhRKAE4p6SuYuiKRbnh6fsp78co0kcGO1K9TNKc3K/0XnqKG8?=
 =?iso-8859-1?Q?G6bnoLq9JB5Yu9rVV5Qi8ohoyBz8T2VFYf+pFESNF76Hx+OERijTKbeaYp?=
 =?iso-8859-1?Q?SNE0sQgvybN4a0+OEx9Plw1wXcItFlcfn962NzXsEsVDeRqyvEjiFqfgpa?=
 =?iso-8859-1?Q?3OfFdbpWNuIQiYam+x387MLErzmwfkKgddiZDWC2kelrjnqM0Oai6LgBYR?=
 =?iso-8859-1?Q?Inhq6y2H9yQTEkr7Q8DkuyFdGARvS6ptrfByek4CurfSSQIyA3y7JndyCR?=
 =?iso-8859-1?Q?xyNMr2zcvanRWCJng/qE3dER8k7nCZfHXED24FiclOvLKNKOkU9jAcVNWm?=
 =?iso-8859-1?Q?F4p2cNU85K3Qo9PuGX4/ikNuZkdcf9T8/Hdu6XQUZLXORwwj6LhCfikF90?=
 =?iso-8859-1?Q?d7RtFBwbiFa8AIqFo0/f6VvhUIi3kbf7fwuaAw8LN6gJmE3w09QgP7uQRs?=
 =?iso-8859-1?Q?GT3NAQpD581bSpU02htuacx+XnBtD36AjrEWxX+xbBMRa49bl5waTEwe62?=
 =?iso-8859-1?Q?lXX56jEHbTaLn7Bhn4uE8bG/WzPu3YyGJA8vnftK9a7FTq1VJPvMrU7ODw?=
 =?iso-8859-1?Q?TsDGBF1pLvz5fA9WV9g6/jNddaJunJ3Sg1/lfMiWvkt0vsHlYl5TYCSBRT?=
 =?iso-8859-1?Q?PlkoyXo9P2zvitySpBOFejRDz0xErnlg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4824.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72925e8d-0a0c-45b4-695b-08d973d7d7c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 21:21:52.3372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vQTMDI8OVk8Kp9A3KX9f+xwm3c5UGFo8TaMT1PKBXosU+0suc44w07PrLC/t+52X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4984
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: AIiiC8XBGpm70DROFNUzeuc1nKthKXJS
X-Proofpoint-ORIG-GUID: AIiiC8XBGpm70DROFNUzeuc1nKthKXJS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_08:2021-09-09,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=719 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

=0A=
On Wed, Sep 08, 2021 at 12:24AM, Eric Biggers wrote:=0A=
> Taking a closer look at this patch, I don't think we should be overloadin=
g the=0A=
> '--key' option and 'keyfile' field like this, as it's confusing.  It's al=
so not=0A=
> really necessary for 'fsverity sign' to do all this option validation its=
elf; I=0A=
> think we should keep it simple and just rely on libfsverity.=0A=
> =0A=
> Also, I think this feature could use clearer documentation that clearly e=
xplains=0A=
> that there are now two ways to specify a private key.=0A=
> =0A=
> I ended up making the above changes and cleaning up a bunch of other thin=
gs; can=0A=
> you consider the following patch instead?  Thanks!=0A=
=0A=
Your patch looks good to me! I particularly like getting rid of all the=0A=
OPENSSL_IS_BORINGSSL ifdefs and instead returning an error from its=0A=
implementation of load_pkcs11_private_key().=0A=
=0A=
I ran my tests with PKCS#11 token and regular file-based keys, and everythi=
ng=0A=
including error handling seems to be working as expected.=0A=
=0A=
I'll submit this version as V5.=0A=
